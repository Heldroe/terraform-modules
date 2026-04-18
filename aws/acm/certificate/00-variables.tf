variable "domain_name" {
  type        = string
  description = "The main certificate domain name."
}

variable "extra_domain_names" {
  type        = list(string)
  description = "Extra certificate domain names."
}

variable "route53_zone_id" {
  type        = string
  default     = null
  description = "Route53 zone ID to create validation records in."
}

variable "cloudflare_zone_id" {
  type        = string
  default     = null
  description = "Cloudflare zone ID to create validation records in."
}
