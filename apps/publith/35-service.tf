resource "kubernetes_service_v1" "app" {
  metadata {
    name      = local.app_name
    namespace = local.namespace

    labels = {
      app = local.app_name
    }
  }

  spec {
    selector = {
      app = local.app_name
    }

    port {
      name        = "http"
      port        = 80
      target_port = "http"
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
