resource "helm_release" "release" {
  name = var.release_name

  namespace        = var.namespace_name
  create_namespace = var.create_namespace

  repository = var.repository
  chart      = var.chart_name
  version    = var.chart_version

  set = [
    for name, value in var.set_values : {
      name  = name
      value = value
    }
  ]

  values = var.yaml_values

  timeout = var.timeout
}
