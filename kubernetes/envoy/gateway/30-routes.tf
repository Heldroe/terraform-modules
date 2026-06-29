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
          rule.timeouts != null ? {
            timeouts = rule.timeouts
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

resource "kubernetes_manifest" "backend_traffic_policy" {
  for_each = { for key, route in var.http_routes : key => route if route.backend_traffic_policy != null }

  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "BackendTrafficPolicy"

    metadata = {
      name      = each.key
      namespace = local.namespace
    }

    spec = {
      targetRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "HTTPRoute"
          name  = each.key
        },
      ]
      timeout = each.value.backend_traffic_policy.timeout
    }
  }

  depends_on = [kubernetes_manifest.http_route]
}
