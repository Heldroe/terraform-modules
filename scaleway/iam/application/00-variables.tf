variable "name" {
  type        = string
  description = "The IAM application name."
}

variable "description" {
  type        = string
  description = "The IAM application description."
}

variable "project_id" {
  type        = string
  sensitive   = true
  description = "The Scaleway project ID."
}

variable "permission_sets" {
  type        = list(string)
  default     = []
  description = "List of permission sets to grant to the application."
}
