variable "accelerated_pullzone_id" {
  type        = number
  default     = null
  description = "Accelerated pull zone ID created by the DNS records."
}

variable "name" {
  type        = string
  default     = null
  description = "The pull zone name, when creating it."
}

variable "secret_header_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "The origin secret header key."
}

variable "secret_header_value" {
  type        = string
  sensitive   = true
  default     = null
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

variable "origin_path" {
  type        = string
  default     = "/"
  description = "The origin path."
}

variable "origin_scheme" {
  type        = string
  default     = null
  description = "The origin scheme. Can only be used for DNS accelerated pull zones."
}

variable "origin_port" {
  type        = number
  default     = null
  description = "The origin scheme. Can only be used for DNS accelerated pull zone."
}

variable "enable_smart_cache" {
  type        = bool
  default     = true
  description = "Whether to enable Smart Cache."
}

variable "block_root_path" {
  type        = bool
  default     = true
  description = "Whether to block access to root path and subdirectories."
}

variable "force_send_origin_host_header" {
  type        = bool
  default     = false
  description = "Whether to force sending the origin host name as host header."
}

variable "s3_auth_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether requests to origin will be signed with AWS Signature Version 4."
}

variable "s3_auth_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "The access key used to authenticate the requests."
}

variable "s3_auth_secret" {
  type        = string
  sensitive   = true
  default     = null
  description = "The secret key used to authenticate the requests."
}

variable "s3_auth_region" {
  type        = string
  default     = null
  description = "The region name of the bucket used to authenticate the requests."
}

variable "edge_rules" {
  type = map(object({
    enabled     = optional(bool, true)
    description = optional(string)
    priority    = optional(number)
    match_type  = string
    triggers = list(object({
      match_type = string
      parameter1 = optional(string)
      parameter2 = optional(string)
      patterns   = list(string)
      type       = string
    }))
    actions = list(object({
      parameter1 = optional(string)
      parameter2 = optional(string)
      parameter3 = optional(string)
      type       = string
    }))
  }))
  default     = {}
  description = "Map of edge rules to create."
}
