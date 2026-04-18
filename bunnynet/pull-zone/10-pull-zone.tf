resource "bunnynet_pullzone" "zone" {
  name = local.name

  origin {
    type = var.accelerated_pullzone_id != null ? "DnsAccelerate" : "OriginUrl"
    url  = var.accelerated_pullzone_id != null ? data.bunnynet_pullzone.zone[0].origin.url : "https://${var.origin_hostname}${var.origin_path}"

    verify_ssl          = true
    forward_host_header = false
  }

  routing {
    tier = "Standard"
  }

  cache_enabled       = var.enable_smart_cache
  block_root_path     = var.block_root_path
  safehop_enabled     = true
  safehop_retry_count = 2

  # S3 authentication
  s3_auth_enabled = var.s3_auth_enabled
  s3_auth_key     = var.s3_auth_key
  s3_auth_region  = var.s3_auth_region
  s3_auth_secret  = var.s3_auth_secret
}

resource "bunnynet_pullzone_hostname" "additional" {
  for_each = var.additional_hostnames

  pullzone = bunnynet_pullzone.zone.id
  name     = each.key

  tls_enabled = true
  force_ssl   = true
}

resource "bunnynet_pullzone_shield" "shield" {
  pullzone = bunnynet_pullzone.zone.id
  tier     = "Basic"

  ddos {
    level = "Asleep"
    mode  = "Log"
  }

  waf {
    enabled = true
    mode    = "Log"
  }
}

resource "bunnynet_pullzone_edgerule" "origin_headers" {
  count = var.force_send_origin_host_header || local.send_secret_header ? 1 : 0

  enabled     = true
  pullzone    = bunnynet_pullzone.zone.id
  description = "Secret extra origin header"

  actions = concat(
    var.force_send_origin_host_header ? [
      {
        type       = "SetRequestHeader"
        parameter1 = "Host"
        parameter2 = var.origin_hostname
        parameter3 = null # Must be defined
      },
    ] : [],
    local.send_secret_header ? [
      {
        type       = "SetRequestHeader"
        parameter1 = var.secret_header_key
        parameter2 = var.secret_header_value
        parameter3 = null # Must be defined
      },
    ] : []
  )

  match_type = "MatchAny"
  triggers = [
    {
      type       = "Url"
      match_type = "MatchAny"
      patterns   = ["*"]
      parameter1 = null # Must be defined
      parameter2 = null # Must be defined
    },
  ]
}

resource "bunnynet_pullzone_edgerule" "custom" {
  for_each = var.edge_rules

  pullzone = bunnynet_pullzone.zone.id

  enabled     = each.value.enabled
  description = each.value.description
  priority    = each.value.priority
  match_type  = each.value.match_type
  triggers    = each.value.triggers
  actions     = each.value.actions
}
