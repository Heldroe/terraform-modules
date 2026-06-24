resource "kubernetes_manifest" "reference_grant" {
  for_each = var.gateway_namespaces

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "ReferenceGrant"

    metadata = {
      name      = each.key
      namespace = local.namespace
    }

    spec = {
      from = [
        {
          group     = "gateway.networking.k8s.io"
          kind      = "HTTPRoute"
          namespace = each.key
        },
      ]

      to = [
        {
          group = ""
          kind  = "Service"
        },
      ]
    }
  }
}
