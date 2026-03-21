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

variable "external_traffic_policy" {
  type        = string
  default     = "Cluster"
  description = "External traffic policy when using LoadBalancer."
}

variable "clusterip_address" {
  type        = string
  default     = null
  description = "Static IP address when using ClusterIP."
}
