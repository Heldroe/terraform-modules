resource "helm_release" "umami" {
  name = var.release_name

  namespace        = var.namespace_name
  create_namespace = var.create_namespace

  repository = var.repository
  chart      = var.chart_name
  version    = var.chart_version
}
