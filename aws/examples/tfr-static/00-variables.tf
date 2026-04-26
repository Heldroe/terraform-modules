variable "bucket_name" {
  type        = string
  default     = "tfr-static"
  description = "Name of the S3 bucket."
}

variable "description" {
  type        = string
  default     = "Static terraform registry"
  description = "Description of the CloudFront distribution."
}

variable "acl_arn" {
  type        = string
  default     = null
  description = "The Web ACL ARN to use."
}
