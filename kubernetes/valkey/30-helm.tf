module "valkey" {
  source  = "tfr.davidguerrero.fr/modules/helm-release/kubernetes"
  version = "~> 0.1.0"

  release_name     = var.release_name
  namespace_name   = local.namespace
  create_namespace = false

  repository = "https://valkey.io/valkey-helm"

  chart_name    = "valkey"
  chart_version = var.chart_version

  yaml_values = [
    yamlencode({
      metrics = {
        enabled = true
      }
    }),
  ]
}
