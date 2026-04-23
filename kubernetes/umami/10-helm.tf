module "umami" {
  source  = "tfr.davidguerrero.fr/modules/helm-release/kubernetes"
  version = "~> 0.1.0"

  release_name     = var.release_name
  namespace_name   = var.namespace_name
  create_namespace = var.create_namespace

  repository = "https://charts.christianhuth.de"

  chart_name    = "umami"
  chart_version = var.chart_version

  set_values = {
    "service.port"                   = local.service_port
    "postgresql.enabled"             = "false"
    "image.tag"                      = var.image_tag
    "umami.collectApiEndpoint"       = local.api_endpoint
    "umami.trackerScriptName"        = local.script_endpoint
    "externalDatabase.auth.database" = var.database_name
    "externalDatabase.auth.username" = urlencode(var.database_username) # Helm chart writes it to a Database URL
    "externalDatabase.auth.password" = urlencode(var.database_password) # Helm chart writes it to a Database URL
    "externalDatabase.hostname"      = var.database_host
  }
}

moved {
  from = helm_release.umami
  to   = module.umami.helm_release.release
}
