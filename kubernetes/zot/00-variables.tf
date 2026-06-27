variable "chart_version" {
  type        = string
  default     = "0.1.118"
  description = "Helm chart version."
}

variable "release_name" {
  type        = string
  default     = "zot"
  description = "Helm release name."
}

variable "namespace_name" {
  type        = string
  default     = "zot"
  description = "Namespace to install into."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}

# Credentials

variable "credentials" {
  type        = map(string)
  sensitive   = true
  default     = {}
  description = "Map of username => password credentials to create."
}

# Storage

variable "bucket_name" {
  type        = string
  description = "The bucket name."
}

variable "bucket_region" {
  type        = string
  description = "The bucket region."
}

variable "bucket_endpoint" {
  type        = string
  description = "The bucket endpoint."
}

variable "bucket_storage_class" {
  type        = string
  default     = "STANDARD"
  description = "Default storage class for created objects."
}

variable "bucket_access_key" {
  type        = string
  sensitive   = true
  description = "Access key to write to the bucket."
}

variable "bucket_secret_key" {
  type        = string
  sensitive   = true
  description = "Secret key to write to the bucket."
}

# Gateways

variable "gateway_namespaces" {
  type        = set(string)
  default     = []
  description = "The Gateway namespaces to create ReferenceGrants for."
}
