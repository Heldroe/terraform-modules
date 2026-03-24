locals {
  namespace = var.create_namespace ? kubernetes_namespace_v1.namespace[0].metadata[0].name : var.namespace

  escaped_hostnames = {
    for hostname in keys(var.hostnames) : hostname => replace(hostname, ".", "-")
  }

  gateway_affinity = {
    podAntiAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = [
        {
          labelSelector = {
            matchLabels = {
              "gateway.envoyproxy.io/owning-gateway-name" = var.name
            }
          }
          topologyKey = "kubernetes.io/hostname"
        },
      ]
    }
  }

  host_network_patch = {
    patch = {
      value = {
        spec = {
          template = {
            spec = {
              containers = [
                {
                  name = "envoy"
                  ports = [
                    {
                      containerPort = 10080
                      hostPort      = 80
                      name          = "http"
                      protocol      = "TCP"
                    },
                    {
                      containerPort = 10443
                      hostPort      = 443
                      name          = "https"
                      protocol      = "TCP"
                    },
                  ]
                },
              ]
            }
          }
        }
      }
    }
  }
}
