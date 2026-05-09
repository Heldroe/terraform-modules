resource "kubernetes_manifest" "http_route" {
  for_each = var.http_routes

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = each.key
      namespace = local.namespace
    }

    spec = {
      parentRefs = [
        {
          name      = var.name
          namespace = local.namespace
        },
      ]

      hostnames = each.value.hostnames
      rules     = each.value.rules
    }
  }

  depends_on = [kubernetes_manifest.gateway]
}
