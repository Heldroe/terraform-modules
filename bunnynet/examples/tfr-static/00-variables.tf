variable "pull_zone_name" {
  type        = string
  description = "The Bunny.net Pull Zone name."
}

variable "bucket_name" {
  type        = string
  description = "The bucket name."
}

variable "bucket_read_user_name" {
  type        = string
  default     = "tfr-static-read"
  description = "The Scaleway IAM user name for read access to the bucket."
}

variable "bucket_write_user_name" {
  type        = string
  default     = "tfr-static-write"
  description = "The Scaleway IAM user name for write access to the bucket."
}

variable "scaleway_admin_user_ids" {
  type        = list(string)
  sensitive   = true
  description = "List of user IDs to give admin access to the bucket."
}

variable "scaleway_project_id" {
  type        = string
  sensitive   = true
  description = "The Scaleway project ID."
}

variable "bucket_region" {
  type        = string
  default     = "fr-par"
  description = "The bucket region."
}
