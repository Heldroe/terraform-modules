variable "chart_version" {
  type        = string
  default     = "0.10.0"
  description = "Helm chart version."
}

variable "release_name" {
  type        = string
  default     = "valkey"
  description = "Helm release name."
}

variable "namespace_name" {
  type        = string
  default     = "valkey"
  description = "Namespace to install into."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}
