module "zot" {
  source  = "tfr.davidguerrero.fr/modules/helm-release/kubernetes"
  version = "~> 0.1.0"

  release_name     = "zot"
  namespace_name   = local.namespace
  create_namespace = false

  repository = "oci://ghcr.io/project-zot/helm-charts"

  chart_name    = var.release_name
  chart_version = var.chart_version

  yaml_values = [
    yamlencode({
      replicaCount = 1
      env = [
        {
          name = "AWS_ACCESS_KEY_ID"
          valueFrom = {
            secretKeyRef = {
              name = kubernetes_secret_v1.s3.metadata[0].name
              key  = "aws_access_key_id"
            }
          }
        },
        {
          name = "AWS_SECRET_ACCESS_KEY"
          valueFrom = {
            secretKeyRef = {
              name = kubernetes_secret_v1.s3.metadata[0].name
              key  = "aws_secret_access_key"
            }
          }
        },
      ]

      affinity = {
        podAntiAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution = [
            {
              labelSelector = {
                matchLabels = {
                  "app.kubernetes.io/name" = var.release_name
                }
              }
              topologyKey = "kubernetes.io/hostname"
            },
          ]
        }
      }

      mountConfig = true
      configFiles = {
        "config.json" = jsonencode({
          log = {
            level = "debug"
          }
          http = {
            auth = {
              htpasswd = {
                path = "/secret/htpasswd"
              }
            }
            address = "0.0.0.0"
            port    = "5000"
            compat  = ["docker2s2"]
          }
          extensions = {
            search = {
              enable = true
            }
            ui = {
              enable = true
            }
          }
          storage = {
            rootDirectory   = "/tmp/zot"
            dedupe          = false
            redirectBlobURL = true
            storageDriver = {
              name           = "s3"
              rootdirectory  = "/zot"
              bucket         = var.bucket_name
              region         = var.bucket_region
              regionendpoint = var.bucket_endpoint
              storageclass   = var.bucket_storage_class
              secure         = true
              skipverify     = false
              forcepathstyle = true
              # loglevel       = "debug"
            }
          }
        })
      }

      mountSecret = true
      secretFiles = {
        htpasswd = <<EOF
${local.kubernetes_probes_user}:${htpasswd_password.kubernetes_probes.bcrypt}
        EOF
      }
      authHeader = base64encode("${local.kubernetes_probes_user}:${random_password.kubernetes_probes.result}")
      pvc = {
        create = false
      }
    }),
  ]
}
