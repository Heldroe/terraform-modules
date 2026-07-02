resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = local.app_name
    namespace = local.namespace

    labels = {
      app = local.app_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = local.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.app_name
        }
      }

      spec {
        automount_service_account_token = false

        # security_context {
        #   run_as_non_root = true

        #   seccomp_profile {
        #     type = "RuntimeDefault"
        #   }
        # }

        dynamic "image_pull_secrets" {
          for_each = var.registry_credentials != null ? toset([1]) : toset([])

          content {
            name = kubernetes_secret_v1.registry_credentials[0].metadata[0].name
          }
        }

        # # ── Init container: run migrations before app starts ──
        # init_container {
        #   name              = "migrate"
        #   image             = var.image
        #   image_pull_policy = "Always"
        #   command           = ["python", "manage.py", "migrate", "--noinput"]

        #   env {
        #     name = "SECRET_KEY"
        #     value_from {
        #       secret_key_ref {
        #         name = kubernetes_secret_v1.django.metadata[0].name
        #         key  = "secret-key"
        #       }
        #     }
        #   }

        #   env {
        #     name = "DATABASE_URL"
        #     value_from {
        #       secret_key_ref {
        #         name = kubernetes_secret_v1.django.metadata[0].name
        #         key  = "database-url"
        #       }
        #     }
        #   }

        #   env {
        #     name  = "DJANGO_SETTINGS_MODULE"
        #     value = "config.settings.production"
        #   }

        #   security_context {
        #     allow_privilege_escalation = false
        #     read_only_root_filesystem  = true
        #     run_as_non_root            = true
        #     run_as_user                = local.app_uid

        #     capabilities {
        #       drop = ["ALL"]
        #     }
        #   }

        #   volume_mount {
        #     name       = "tmp"
        #     mount_path = "/tmp"
        #   }
        # }

        # ── Main application container ────────────────────────
        container {
          name              = local.app_name
          image             = var.image
          image_pull_policy = "IfNotPresent"

          port {
            name           = "http"
            container_port = 8000 # local.http_port
            protocol       = "TCP"
          }

          # Feed pod IP to allow as valid host for healthchecks
          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          # Load configuration environment variables
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.app_config.metadata[0].name
              optional = false
            }
          }

          # Load secret environment variables
          env_from {
            secret_ref {
              name     = kubernetes_secret_v1.app_secrets.metadata[0].name
              optional = false
            }
          }

          # ── Security ───────────────────────────────────────
          # security_context {
          #   allow_privilege_escalation = false
          #   # read_only_root_filesystem  = true
          #   run_as_non_root = true

          #   capabilities {
          #     drop = ["ALL"]
          #   }
          # }

          # # ── Environment ────────────────────────────────────
          # env {
          #   name = "SECRET_KEY"
          #   value_from {
          #     secret_key_ref {
          #       name = kubernetes_secret_v1.django.metadata[0].name
          #       key  = "secret-key"
          #     }
          #   }
          # }

          # env {
          #   name = "DATABASE_URL"
          #   value_from {
          #     secret_key_ref {
          #       name = kubernetes_secret_v1.django.metadata[0].name
          #       key  = "database-url"
          #     }
          #   }
          # }

          # env {
          #   name  = "DJANGO_SETTINGS_MODULE"
          #   value = "config.settings.production"
          # }

          # env {
          #   name  = "PORT"
          #   value = tostring(local.http_port)
          # }

          # env {
          #   name  = "GUNICORN_WORKERS"
          #   value = tostring(var.gunicorn_workers)
          # }

          # ── Resources ──────────────────────────────────────
          # resources {
          #   requests = {
          #     cpu    = var.resources.requests.cpu
          #     memory = var.resources.requests.memory
          #   }
          #   limits = {
          #     memory = var.resources.limits.memory
          #   }
          # }

          # ── Probes ─────────────────────────────────────────
          # startup_probe {
          #   http_get {
          #     path = "/healthz/"
          #     port = "http"
          #   }
          #   failure_threshold = 12
          #   period_seconds    = 5
          # }

          # liveness_probe {
          #   http_get {
          #     path = "/healthz/"
          #     port = "http"
          #   }
          #   period_seconds    = 10
          #   timeout_seconds   = 5
          #   failure_threshold = 3
          # }

          # readiness_probe {
          #   http_get {
          #     path = "/readyz/"
          #     port = "http"
          #   }
          #   period_seconds    = 5
          #   timeout_seconds   = 3
          #   failure_threshold = 2
          # }

          # ── Volume mounts ──────────────────────────────────
          # volume_mount {
          #   name       = "tmp"
          #   mount_path = "/tmp"
          # }

          # volume_mount {
          #   name       = "django-secrets"
          #   mount_path = "/run/secrets/django"
          #   read_only  = true
          # }
        }

        # ── Volumes ────────────────────────────────────────────
        # volume {
        #   name = "tmp"
        #   empty_dir {
        #     medium     = "Memory"
        #     size_limit = "64Mi"
        #   }
        # }

        # volume {
        #   name = "django-secrets"
        #   secret {
        #     secret_name  = kubernetes_secret_v1.django.metadata[0].name
        #     default_mode = "0400"
        #   }
        # }

        # # ── Topology spread ────────────────────────────────────
        # topology_spread_constraint {
        #   max_skew           = 1
        #   topology_key       = "kubernetes.io/hostname"
        #   when_unsatisfiable = "DoNotSchedule"

        #   label_selector {
        #     match_labels = {
        #       app = local.app_name
        #     }
        #   }
        # }
      }
    }
  }

  # Version is managed by CD
  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].image,
    ]
  }
}

# ============================================================
# Secret (placeholder — populate via CI / external-secrets)
# ============================================================
# In a real workflow, do NOT store plaintext values in Terraform state.
# Either:
#   a) Use the External Secrets Operator and omit this resource entirely, or
#   b) Source values from a secrets manager (Vault, AWS SSM) via data sources.
# resource "kubernetes_secret_v1" "django" {
#   metadata {
#     name      = "${local.app_name}-secrets"
#     namespace = var.namespace
#   }

#   # sensitive() prevents values appearing in plan output
#   data = {
#     "secret-key"   = sensitive(var.django_secret_key)
#     "database-url" = sensitive(var.database_url)
#   }

#   type = "Opaque"
# }
