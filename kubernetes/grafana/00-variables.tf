variable "namespace_name" {
  type        = string
  default     = "grafana"
  description = "The installation namespace."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}

variable "admin_username" {
  type        = string
  sensitive   = true
  default     = "grafana"
  description = "The default admin username."
}

variable "chart_version" {
  type        = string
  default     = "12.4.1"
  description = "Helm chart version."
}

variable "image_tag" {
  type        = string
  default     = "13.1.0-25893932881-ubuntu"
  description = "The image tag."
}

variable "resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
  })
  default     = {}
  description = "Resource requests & limits."
}

variable "database_host" {
  type        = string
  description = "Database host."
}

variable "database_name" {
  type        = string
  default     = "umami"
  description = "Database name."
}

variable "database_username" {
  type        = string
  sensitive   = true
  description = "Database username."
}

variable "database_password" {
  type        = string
  sensitive   = true
  description = "Database password."
}

variable "vmselect_host" {
  type        = string
  description = "The service hostname to reach vmselect on."
}

variable "vm_scrape_interval" {
  type        = string
  description = "The scrape interval defined in vmagent (e.g. '10s')."
}

variable "logs_bucket_name" {
  type        = string
  description = "The logs bucket name."
}

variable "logs_bucket_endpoint" {
  type        = string
  description = "The logs bucket endpoint."
}

variable "logs_bucket_region" {
  type        = string
  description = "The logs bucket region."
}

variable "logs_bucket_access_key_id" {
  type        = string
  sensitive   = true
  description = "The logs bucket access key ID."
}

variable "logs_bucket_secret_access_key" {
  type        = string
  sensitive   = true
  description = "The logs bucket secret access key."
}

variable "logs_daily_compaction" {
  type        = bool
  default     = false
  description = "Whether to use daily compacted logs when querying."
}

variable "gateway_namespaces" {
  type        = set(string)
  default     = []
  description = "The Gateway namespaces to create ReferenceGrants for."
}
