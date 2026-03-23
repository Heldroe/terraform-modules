variable "name" {
  type        = string
  default     = "parseable"
  description = "The release name."
}

variable "namespace" {
  type        = string
  default     = "parseable"
  description = "Namespace to install into."
}

variable "create_namespace" {
  type        = string
  default     = true
  description = "Whether to create the namespace."
}

variable "enable_ha" {
  type        = bool
  default     = false
  description = "Whether to run in high availability mode."
}

variable "ingestor_ha_replicas" {
  type        = number
  default     = 3
  description = "Number of ingestor replicas when running in HA mode."
}

variable "install_filebeat" {
  type        = bool
  default     = false
  description = "Whether to install filebeat to ship Kubernetes logs to Parseable."
}

variable "admin_username" {
  type        = string
  sensitive   = true
  default     = "parseable"
  description = "Default admin username."
}

variable "admin_password" {
  type        = string
  sensitive   = true
  default     = null
  description = "Default admin password, will be generated if not provided."
}

variable "s3_bucket" {
  type        = string
  description = "The storage bucket name."
}

variable "s3_region" {
  type        = string
  description = "The storage bucket region."
}

variable "s3_access_key" {
  type        = string
  sensitive   = true
  description = "The storage bucket access key."
}

variable "s3_secret_key" {
  type        = string
  sensitive   = true
  description = "The storage bucket secret key."
}

variable "log_level" {
  type        = string
  default     = "warn"
  description = "The log level to use."
}
