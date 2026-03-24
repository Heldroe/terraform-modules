variable "name" {
  type        = string
  description = "The bucket name."
}

variable "add_random_suffix" {
  type        = bool
  default     = true
  description = "Whether to add a random suffix to the bucket name."
}

variable "random_suffix_length" {
  type        = number
  default     = 8
  description = "Length of the bucket random suffix, if enabled."
}

variable "region" {
  type        = string
  description = "The bucket region."
}

variable "readonly_application_ids" {
  type        = list(string)
  default     = []
  description = "List of application IDs to grant read access to the bucket."
}

variable "readwrite_application_ids" {
  type        = list(string)
  default     = []
  description = "List of application IDs to grant read+write access to the bucket."
}

variable "admin_user_ids" {
  type        = list(string)
  default     = []
  description = "List of user IDs to grant admin access to the bucket."
}

variable "admin_application_ids" {
  type        = list(string)
  default     = []
  description = "List of application IDs to grant admin access to the bucket."
}
