variable "repository" {
  type        = string
  description = "Helm repository URL."
}

variable "chart_name" {
  type        = string
  description = "Helm chart name."
}

variable "chart_version" {
  type        = string
  description = "Helm chart version."
}

variable "release_name" {
  type        = string
  description = "Helm release name."
}

variable "namespace_name" {
  type        = string
  description = "Namespace to install into."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}
