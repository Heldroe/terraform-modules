resource "kubernetes_cron_job_v1" "compactor" {
  for_each = local.compactor_jobs

  metadata {
    name      = each.value.name
    namespace = local.namespace
    labels    = { app = local.compactor_app_label }
  }

  spec {
    schedule                      = each.value.schedule
    concurrency_policy            = "Forbid"
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 3

    job_template {
      metadata {
        labels = { app = local.compactor_app_label }
      }
      spec {
        template {
          metadata {
            labels = { app = local.compactor_app_label }
          }
          spec {
            restart_policy = "OnFailure"

            container {
              name              = "compactor"
              image             = var.compactor_image
              image_pull_policy = "IfNotPresent"

              resources {
                requests = local.compactor_resources.requests
                limits   = local.compactor_resources.limits
              }

              env {
                name  = "MODE"
                value = each.value.mode
              }
              env {
                name  = "DELETE_FILES"
                value = "true"
              }

              # Common env vars
              dynamic "env" {
                for_each = local.compactor_common_env

                content {
                  name  = env.key
                  value = env.value
                }
              }

              # S3 credentials
              dynamic "env" {
                for_each = local.compactor_secret_env

                content {
                  name = env.value.name
                  value_from {
                    secret_key_ref {
                      name = kubernetes_secret_v1.bucket.metadata[0].name
                      key  = env.value.secret_key
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
}
