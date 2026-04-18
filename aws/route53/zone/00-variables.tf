variable "domain_name" {
  type        = string
  description = "The zone's domain name."
}

variable "mx_records" {
  type        = map(list(string))
  default     = {}
  description = "Map of domain => MX records to create."
}

variable "txt_records" {
  type        = map(list(string))
  default     = {}
  description = "Map of domain => TXT records to create."
}
