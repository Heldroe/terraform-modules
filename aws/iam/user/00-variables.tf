variable "name" {
  type        = string
  description = "Name of the user, region will be appended to the name."
}

variable "policy_arns" {
  type = set(string)

  default = []

  description = "IAM policy ARNs to attach to the user."
}
