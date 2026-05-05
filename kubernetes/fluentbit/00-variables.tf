variable "namespace_name" {
  type        = string
  default     = "fluentbit"
  description = "The installation namespace."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create the namespace."
}

variable "chart_version" {
  type        = string
  description = "The fluentbit chart version."
}

variable "image_repository" {
  type        = string
  default     = "public.ecr.aws/aws-observability/aws-for-fluent-bit"
  description = "The fluentbit image repository."
}

variable "image_tag" {
  type        = string
  description = "The fluentbit image tag."
}

variable "bucket_name" {
  type        = string
  description = "The output S3 bucket name."
}

variable "bucket_region" {
  type        = string
  description = "The output S3 bucket region."
}

variable "bucket_endpoint" {
  type        = string
  description = "The output S3 bucket endpoint."
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
