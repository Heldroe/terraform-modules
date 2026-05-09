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

variable "compactor_image" {
  type        = string
  default     = "ghcr.io/heldroe/parquet-compactor:sha-14b9322"
  description = "The compactor image and tag to use."
}

variable "hourly_compactor_schedule" {
  type        = string
  default     = "15 * * * *" # Minute 15 past every hour
  description = "Cron schedule for the hourly compaction job."
}

variable "daily_compactor_schedule" {
  type        = string
  default     = "30 2 * * *" # 02:30 every day
  description = "Cron schedule for the daily compaction job."
}

variable "enable_daily_compactor" {
  type        = bool
  default     = false
  description = "Whether to enable the daily compactor job."
}
