variable "client_groups" {
  type        = set(string)
  default     = []
  description = "List of NetBird client groups to create."
}

variable "remote_cluster_groups" {
  type = map(object({
    kubernetes_api_ip      = optional(string, "10.43.0.1")
    private_ingress_ip     = optional(string, "10.43.250.250")
    private_ingress_domain = string
  }))
  default     = {}
  description = "Map of NetBird remote cluster groups to create."
}

variable "setup_keys" {
  type = map(object({
    expiry_seconds         = optional(number, 3600)
    type                   = optional(string, "one-off")
    allow_extra_dns_labels = optional(bool, true)
    groups                 = optional(set(string), [])
    ephemeral              = optional(bool, true)
    usage_limit            = optional(number, 1)
  }))
  default     = {}
  description = "Setup keys to create."
}
