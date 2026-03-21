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
