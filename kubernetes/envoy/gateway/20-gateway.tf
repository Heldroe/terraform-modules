resource "kubernetes_manifest" "gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"

    metadata = {
      name = var.name
      # No namespace, this is a global resource
    }

    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
      parametersRef = {
        group     = "gateway.envoyproxy.io"
        kind      = "EnvoyProxy"
        name      = var.name
        namespace = var.controller_namespace
      }
    }
  }
}

resource "kubernetes_manifest" "envoyproxy" {
  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "EnvoyProxy"
    metadata = {
      name      = var.name
      namespace = var.controller_namespace
    }
    spec = {
      provider = {
        type = "Kubernetes"
        kubernetes = merge(
          {
            envoyService = merge(
              {
                type = var.service_type
              },
              var.service_type == "LoadBalancer" ? {
                externalTrafficPolicy = var.external_traffic_policy
              } : {}
            )
          },
          var.use_daemonset ? {
            envoyDaemonSet = merge(
              {
                name = "envoy-gateway-${var.name}"
                pod = merge(
                  {
                    affinity = local.gateway_affinity
                  },
                  var.use_host_networking ? {
                    nodeSelector = {
                      "node-role.davidguerrero.fr/public-ingress" = "true"
                    }
                  } : {}
                )
              },
              var.use_host_networking ? local.host_network_patch : {}
            )
          } : {},
          !var.use_daemonset ? {
            envoyDeployment = merge(
              {
                name     = "envoy-gateway-${var.name}"
                replicas = var.replicas
                pod = {
                  affinity = local.gateway_affinity
                }
              },
              var.use_host_networking ? local.host_network_patch : {}
            )
          } : {}
        )
      }
    }
  }

  # It's important to create the EnvoyProxy after the Gateway
  # to get the proper IP address assigned to the ClusterIP service.
  depends_on = [kubernetes_manifest.gateway]
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = var.name
      namespace = local.namespace
      annotations = {
        "cert-manager.io/cluster-issuer" = var.cluster_issuer_name
      }
    }

    spec = merge({
      gatewayClassName = var.name
      listeners = concat(
        var.enable_http_healthcheck || var.redirect_http_to_https ? [
          {
            name     = "http"
            protocol = "HTTP"
            port     = var.http_port
          },
        ] : [],
        [
          for hostname, config in var.hostnames :
          {
            name     = "https"
            protocol = "HTTPS"
            port     = var.https_port
            hostname = hostname
            allowedRoutes = {
              namespaces = {
                from = "All"
              }
            }
            tls = {
              mode = "Terminate"
              certificateRefs = [
                {
                  name = "${local.escaped_hostnames[hostname]}-gateway-tls-cert"
                },
              ]
            }
          } if config.allow_apex
        ],
        [
          for hostname, config in var.hostnames :
          {
            name     = "https-wildcard"
            protocol = "HTTPS"
            port     = var.https_port
            hostname = "*.${hostname}"
            allowedRoutes = {
              namespaces = {
                from = "All"
              }
            }
            tls = {
              mode = "Terminate"
              certificateRefs = [
                {
                  name = "${local.escaped_hostnames[hostname]}-gateway-tls-cert"
                },
              ]
            }
          } if config.allow_wildcard
        ]
      )
      },
      var.service_type == "ClusterIP" && var.clusterip_address != null ? {
        addresses = [
          {
            type  = "IPAddress"
            value = var.clusterip_address
          },
        ]
      } : {}
    )
  }

  depends_on = [kubernetes_manifest.gateway_class]
}

resource "kubernetes_manifest" "http_to_https_redirect" {
  count = var.redirect_http_to_https ? 1 : 0

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "${var.name}-http-to-https-redirect"
      namespace = local.namespace
    }
    spec = {
      parentRefs = [
        {
          name        = var.name
          sectionName = "http"
        },
      ]
      rules = [
        {
          filters = [
            {
              type = "RequestRedirect"
              requestRedirect = {
                scheme     = "https"
                statusCode = 301
              }
            },
          ]
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "x_forwarded_for" {
  count = var.accept_x_forwarded_for ? 1 : 0

  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "ClientTrafficPolicy"
    metadata = {
      name      = "${var.name}-x-forwarded-for"
      namespace = local.namespace
    }
    spec = {
      targetRefs = [
        {
          group       = "gateway.networking.k8s.io"
          kind        = "Gateway"
          name        = var.name
          sectionName = "https"
        },
      ]
      clientIPDetection = {
        xForwardedFor = {
          numTrustedHops = var.x_forwarded_for_trusted_hops
        }
      }
    }
  }
}

resource "kubernetes_manifest" "secret_headers" {
  count = length(var.secret_headers) > 0 ? 1 : 0

  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "SecurityPolicy"
    metadata = {
      name      = "${var.name}-secret-headers"
      namespace = local.namespace
    }
    spec = {
      targetRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "Gateway"
          name  = var.name
        },
      ]
      authorization = {
        defaultAction = "Deny"
        rules = [
          for name, config in var.secret_headers : {
            name   = name
            action = "Allow"
            principal = {
              headers = [
                {
                  name   = config.header
                  values = config.values
                },
              ]
            }
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "http_health_check" {
  count = var.enable_http_healthcheck ? 1 : 0

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "http-health-check"
      namespace = local.namespace
    }
    spec = {
      parentRefs = [
        {
          name        = var.name
          sectionName = "http"
        },
      ]
      rules = [
        {
          matches = [{ path = { type = "Exact", value = "/" } }]
          filters = [
            {
              type = "ExtensionRef"
              extensionRef = {
                group = "gateway.envoyproxy.io"
                kind  = "HTTPRouteFilter"
                name  = "health-ok"
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [kubernetes_manifest.health_check_route_filter]
}

resource "kubernetes_manifest" "http_health_check_policy" {
  count = var.enable_http_healthcheck ? 1 : 0

  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "SecurityPolicy"
    metadata = {
      name      = "http-health-check"
      namespace = local.namespace
    }
    spec = {
      targetRefs = [
        {
          "group" = "gateway.networking.k8s.io"
          "kind"  = "HTTPRoute"
          "name"  = "http-health-check"
        },
      ]
      authorization = { defaultAction = "Allow" }
    }
  }

  depends_on = [kubernetes_manifest.http_health_check]
}

resource "kubernetes_manifest" "health_check_route_filter" {
  count = var.enable_http_healthcheck ? 1 : 0

  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "HTTPRouteFilter"
    metadata = {
      name      = "health-ok"
      namespace = local.namespace
    }
    spec = {
      directResponse = {
        statusCode = 200
        body = {
          type   = "Inline"
          inline = "OK"
        }
      }
    }
  }
}
