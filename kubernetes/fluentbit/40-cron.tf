resource "kubernetes_cron_job_v1" "parquet_compactor" {
  metadata {
    name      = "parquet-compactor"
    namespace = local.namespace
    labels = {
      app = "parquet-compactor"
    }
  }

  spec {
    schedule                      = var.compactor_schedule
    concurrency_policy            = "Forbid"
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 3

    job_template {
      metadata {
        labels = {
          app = "parquet-compactor"
        }
      }
      spec {
        template {
          metadata {
            labels = {
              app = "parquet-compactor"
            }
          }
          spec {
            restart_policy = "OnFailure"

            container {
              name              = "compactor"
              image             = var.compactor_image
              image_pull_policy = "IfNotPresent"

              resources {
                requests = {
                  cpu    = "100m"
                  memory = "100Mi"
                }
                limits = {
                  cpu    = "500m"
                  memory = "250Mi"
                }
              }

              # Logs config
              env {
                name  = "BUCKET_NAME"
                value = var.bucket_name
              }
              env {
                name  = "S3_ENDPOINT"
                value = var.bucket_endpoint
              }
              env {
                name  = "S3_REGION"
                value = var.bucket_region
              }
              env {
                name  = "CATEGORIES"
                value = "containers"
              }
              env {
                name  = "DELETE_RAW_FILES"
                value = "true"
              }

              # S3 credentials
              env {
                name = "AWS_ACCESS_KEY_ID"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret_v1.bucket.metadata[0].name
                    key  = "aws_access_key_id"
                  }
                }
              }
              env {
                name = "AWS_SECRET_ACCESS_KEY"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret_v1.bucket.metadata[0].name
                    key  = "aws_secret_access_key"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
