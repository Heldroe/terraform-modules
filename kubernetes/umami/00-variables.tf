variable "chart_version" {
  type        = string
  default     = "7.6.0"
  description = "Helm chart version."
}

variable "release_name" {
  type        = string
  default     = "umami"
  description = "Helm release name."
}

variable "namespace_name" {
  type        = string
  default     = "umami"
  description = "Namespace to install into."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}

variable "image_tag" {
  type        = string
  description = "Docker image tag."
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

# Gateways

variable "public_gateway" {
  type = object({
    name      = string
    namespace = string
    domain    = string
  })
  default     = null
  description = "Public Gateway settings."
}

variable "private_gateway" {
  type = object({
    name      = string
    namespace = string
    domain    = string
  })
  default     = null
  description = "Private Gateway settings."
}
