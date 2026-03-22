variable "accelerated_pullzone_id" {
  type        = number
  description = "Accelerated pull zone ID created by the DNS records."
}

variable "secret_header_key" {
  type        = string
  sensitive   = true
  description = "The origin secret header key."
}

variable "secret_header_value" {
  type        = string
  sensitive   = true
  description = "The origin secret header value."
}

variable "additional_hostnames" {
  type        = set(string)
  description = "List of additional hostnames to accept."
}

variable "origin_hostname" {
  type        = string
  description = "The origin host name."
}
