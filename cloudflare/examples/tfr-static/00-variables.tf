variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID."
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID."
}

variable "bucket_name" {
  type        = string
  default     = "tfr-static"
  description = "The R2 bucket name."
}

variable "bucket_location" {
  type        = string
  default     = "WEUR"
  description = "The R2 bucket location (see https://developers.cloudflare.com/r2/reference/data-location/#available-hints)."
}

variable "registry_domain" {
  type        = string
  description = "The registry's domain."
}
