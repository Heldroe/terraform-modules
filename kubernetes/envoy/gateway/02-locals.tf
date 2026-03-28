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

  # The first port in the ephemeral port range.
  # https://github.com/envoyproxy/gateway/blob/fae7f1975fec116b48df9385ebbe49e750746cb2/internal/gatewayapi/translator.go#L45
  min_ephemeral_port = 1024
  # Constant added to the well known port (1-1023) to convert it into an ephemeral port.
  # https://github.com/envoyproxy/gateway/blob/fae7f1975fec116b48df9385ebbe49e750746cb2/internal/gatewayapi/translator.go#L48
  well_known_port_shift = 10000

  # Determine envoy gateway container ports
  http_container_port  = var.http_port < local.min_ephemeral_port ? var.http_port + local.well_known_port_shift : var.http_port
  https_container_port = var.https_port < local.min_ephemeral_port ? var.https_port + local.well_known_port_shift : var.https_port

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
                      containerPort = local.http_container_port
                      hostPort      = var.http_port
                      name          = "http"
                      protocol      = "TCP"
                    },
                    {
                      containerPort = local.https_container_port
                      hostPort      = var.https_port
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
