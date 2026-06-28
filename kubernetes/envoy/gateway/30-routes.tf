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
      rules = [
        for rule in each.value.rules : merge(
          {
            backendRefs = rule.backendRefs
          },
          rule.matches != null ? {
            matches = rule.matches
          } : {},
          length(rule.filters) > 0 ? {
            filters = [
              for f in rule.filters : merge(
                { type = f.type },
                f.type == "URLRewrite" ? {
                  urlRewrite = f.urlRewrite
                } : {},
                f.type == "RequestRedirect" ? {
                  requestRedirect = f.requestRedirect
                } : {},
                f.type == "RequestHeaderModifier" ? {
                  requestHeaderModifier = f.requestHeaderModifier
                } : {},
                f.type == "ResponseHeaderModifier" ? {
                  responseHeaderModifier = f.responseHeaderModifier
                } : {}
              )
            ]
          } : {}
        )
      ]
    }
  }

  depends_on = [kubernetes_manifest.gateway]
}
