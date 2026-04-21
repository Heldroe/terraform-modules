resource "helm_release" "umami" {
  name = var.release_name

  namespace        = var.namespace_name
  create_namespace = var.create_namespace

  repository = "https://charts.christianhuth.de"

  chart   = "umami"
  version = var.chart_version

  set = [
    {
      name  = "service.port"
      value = local.service_port
    },
    {
      name  = "postgresql.enabled"
      value = "false"
    },
    {
      name  = "image.tag"
      value = var.image_tag
    },
    {
      name  = "umami.collectApiEndpoint"
      value = local.api_endpoint
    },
    {
      name  = "umami.trackerScriptName"
      value = local.script_endpoint
    },
    {
      name  = "externalDatabase.auth.database"
      value = var.database_name
    },
    {
      name  = "externalDatabase.auth.username"
      value = urlencode(var.database_username) # Helm chart writes it to a Database URL
    },
    {
      name  = "externalDatabase.auth.password"
      value = urlencode(var.database_password) # Helm chart writes it to a Database URL
    },
    {
      name  = "externalDatabase.hostname"
      value = var.database_host
    },
  ]
}
