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

variable "set_values" {
  type        = map(string)
  default     = {}
  description = "Map of values to set for single values."
}

variable "yaml_values" {
  type        = list(string)
  default     = []
  description = "List of values in raw YAML."
}

variable "timeout" {
  type        = number
  default     = 300
  description = "Operation timeout."
}
