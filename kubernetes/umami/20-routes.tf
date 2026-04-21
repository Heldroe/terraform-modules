resource "kubernetes_manifest" "httproute_private" {
  count = var.private_gateway != null ? 1 : 0

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "private"
      namespace = var.namespace_name
    }

    spec = {
      parentRefs = [
        {
          name      = var.private_gateway.name
          namespace = var.private_gateway.namespace
        },
      ]

      hostnames = ["umami.${var.private_gateway.domain}"]

      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            },
          ]

          backendRefs = [
            {
              kind = "Service"
              name = var.release_name
              port = local.service_port
            },
          ]
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "httproute_public" {
  count = var.public_gateway != null ? 1 : 0

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "public"
      namespace = var.namespace_name
    }

    spec = {
      parentRefs = [
        {
          name      = var.public_gateway.name
          namespace = var.public_gateway.namespace
        },
      ]

      hostnames = [
        var.public_gateway.domain,
      ]

      rules = [
        {
          matches = [
            {
              path = {
                type  = "Exact"
                value = local.api_endpoint
              }
            },
            {
              path = {
                type  = "Exact"
                value = local.script_endpoint
              }
            },
          ]
          backendRefs = [
            {
              kind = "Service"
              name = var.release_name
              port = local.service_port
            },
          ]
        },
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = local.pixel_prefix
              }
            },
          ]
          filters = [
            {
              type = "URLRewrite"
              urlRewrite = {
                path = {
                  type               = "ReplacePrefixMatch"
                  replacePrefixMatch = "/p/"
                }
              }
            },
          ]
          backendRefs = [
            {
              kind = "Service"
              name = var.release_name
              port = local.service_port
            },
          ]
        },
      ]
    }
  }
}
