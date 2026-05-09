variable "name" {
  type        = string
  description = "The Envoy Gateway name."
}

variable "namespace" {
  type        = string
  default     = "envoy-gateway-system"
  description = "The Gateway's namespace."
}

variable "create_namespace" {
  type        = string
  default     = false
  description = "Whether to create the namespace."
}

variable "controller_namespace" {
  type        = string
  default     = "envoy-gateway-system"
  description = "The Envoy Gateway controller's namespace."
}

variable "cluster_issuer_name" {
  type        = string
  default     = "letsencrypt"
  description = "The cert-manager ClusterIssuer name to use for certificate generation."
}

variable "replicas" {
  type        = number
  default     = 2
  description = "Envoy proxy pods replicas."
}

variable "hostnames" {
  type = map(object({
    allow_apex     = optional(bool, true)
    allow_wildcard = optional(bool, false)
  }))
  default     = {}
  description = "Gateway hostnames configuration."
}

variable "http_port" {
  type        = number
  default     = 80
  description = "HTTP port."
}

variable "https_port" {
  type        = number
  default     = 443
  description = "HTTPS port."
}

variable "enable_http_healthcheck" {
  type        = bool
  default     = false
  description = "Whether to enable an healthcheck response on the HTTP port (used by Bunny.net DNS health checks)."
}

variable "redirect_http_to_https" {
  type        = bool
  default     = false
  description = "Whether to redirect HTTP to HTTPS."
}

variable "service_type" {
  type        = string
  default     = "LoadBalancer"
  description = "The Kubernetes Service type."
}

variable "use_daemonset" {
  type        = bool
  default     = false
  description = "Whether to deploy Envoy as DaemonSet instead of Deployment."
}

variable "use_host_networking" {
  type        = bool
  default     = false
  description = "Whether to listen to the host network directly."
}

variable "external_traffic_policy" {
  type        = string
  default     = "Local"
  description = "External traffic policy when using LoadBalancer."
}

variable "clusterip_address" {
  type        = string
  default     = null
  description = "Static IP address when using ClusterIP."
}

variable "accept_x_forwarded_for" {
  type        = bool
  default     = false
  description = "Whether to accept the X-Forwarded-For header to determine source IP."
}

variable "x_forwarded_for_trusted_hops" {
  type        = number
  default     = 1
  description = "Number of trusted hops for the X-Forwarded-For header."
}

variable "secret_headers" {
  type = map(object({
    header = string
    values = list(string)
  }))
  sensitive   = true
  default     = {}
  description = "Map of name => secret headers enforced to accept ingress traffic."
}

variable "http_routes" {
  type = map(object({
    hostnames = list(string)

    rules = list(object({
      matches = optional(list(object({
        path = optional(object({
          type  = optional(string, "PathPrefix")
          value = optional(string, "/")
        }))
        })), [
        {
          path = {
            type  = "PathPrefix"
            value = "/"
          }
        },
      ])

      backendRefs = list(object({
        name      = string
        port      = number
        namespace = optional(string)
        weight    = optional(number, 1)
      }))

      filters = optional(list(object({
        type = string

        requestHeaderModifier = optional(object({
          add = optional(list(object({
            name  = string
            value = string
          })), [])

          set = optional(list(object({
            name  = string
            value = string
          })), [])

          remove = optional(list(string), [])
        }))

        responseHeaderModifier = optional(object({
          add = optional(list(object({
            name  = string
            value = string
          })), [])

          set = optional(list(object({
            name  = string
            value = string
          })), [])

          remove = optional(list(string), [])
        }))

        requestRedirect = optional(object({
          scheme     = optional(string)
          hostname   = optional(string)
          port       = optional(number)
          statusCode = optional(number)
        }))

        urlRewrite = optional(object({
          hostname = optional(string)
          path = optional(object({
            type               = string
            replaceFullPath    = optional(string)
            replacePrefixMatch = optional(string)
          }))
        }))
      })), [])
    }))
  }))

  default     = {}
  description = "Map of name => HTTPRoute definition."
}
