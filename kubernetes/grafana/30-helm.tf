module "grafana" {
  source  = "tfr.davidguerrero.fr/modules/helm-release/kubernetes"
  version = "~> 0.1.0"

  release_name     = "grafana"
  namespace_name   = local.namespace
  create_namespace = false

  repository = "oci://ghcr.io/grafana-community/helm-charts"

  chart_name    = "grafana"
  chart_version = var.chart_version

  yaml_values = [
    yamlencode({
      adminUser     = var.admin_username
      adminPassword = random_password.admin.result

      image = {
        tag = var.image_tag
      }

      envValueFrom = {
        GF_DATABASE_PASSWORD = {
          secretKeyRef = {
            name = kubernetes_secret_v1.db.metadata[0].name
            key  = "password"
          }
        }
        AWS_ACCESS_KEY_ID = {
          secretKeyRef = {
            name = kubernetes_secret_v1.s3.metadata[0].name
            key  = "aws_access_key_id"
          }
        }
        AWS_SECRET_ACCESS_KEY = {
          secretKeyRef = {
            name = kubernetes_secret_v1.s3.metadata[0].name
            key  = "aws_secret_access_key"
          }
        }
      }

      "grafana.ini" = {
        database = {
          type     = "postgres"
          host     = var.database_host
          name     = var.database_name
          user     = var.database_username
          ssl_mode = "disable"
        }
        plugins = {
          allow_loading_unsigned_plugins = "motherduck-duckdb-datasource"
          forward_host_env_vars          = "motherduck-duckdb-datasource"
        }
      }

      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "VictoriaMetrics"
              type      = "prometheus"
              url       = "http://${var.vmselect_host}/select/0/prometheus"
              access    = "proxy"
              isDefault = true
              jsonData = {
                # Needs to match the vmagent config
                timeInterval = "10" # Must be a string
              }
            },
            {
              name   = "DuckDB logs"
              type   = "motherduck-duckdb-datasource"
              access = "proxy"

              jsonData = {
                path = ""
                initSql = templatefile("${path.module}/duckdb/init.sql", {
                  s3_endpoint      = var.logs_bucket_endpoint
                  s3_region        = var.logs_bucket_region
                  s3_bucket_name   = var.logs_bucket_name
                  daily_compaction = var.logs_daily_compaction
                })
              }
            },
          ]
        }
      }

      persistence = {
        enabled = false
      }

      plugins = [
        # FIXME: use release from https://github.com/motherduckdb/grafana-duckdb-datasource once released
        "motherduck-duckdb-datasource@0.4.2@https://tfr.davidguerrero.fr/motherduck-duckdb-datasource-0.4.2.zip",
      ]

    }),
  ]
}
