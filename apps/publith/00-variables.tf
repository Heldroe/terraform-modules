variable "namespace_name" {
  type        = string
  default     = "publith"
  description = "The namespace name."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Default number of pods."
}

variable "image" {
  type        = string
  description = "The full image path and tag."
}

variable "registry_credentials" {
  type = object({
    domain   = string
    username = string
    password = string
  })
  sensitive   = true
  default     = null
  description = "Image registry credentials."
}

variable "database_host" {
  type        = string
  description = "Database host."
}

variable "database_name" {
  type        = string
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

variable "cache_url" {
  type        = string
  sensitive   = true
  description = "Full cache URL."
}

variable "config" {
  type        = map(string)
  default     = {}
  description = "Map of environment variables to set."
}

variable "gateway_namespaces" {
  type        = set(string)
  default     = []
  description = "The Gateway namespaces to create ReferenceGrants for."
}
