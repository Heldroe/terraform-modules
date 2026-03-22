resource "bunnynet_pullzone" "zone" {
  name = data.bunnynet_pullzone.zone.name

  origin {
    type = "DnsAccelerate"
    url  = data.bunnynet_pullzone.zone.origin.url

    verify_ssl          = true
    forward_host_header = false
  }

  routing {
    tier = "Standard"
  }

  cache_enabled       = true
  block_root_path     = true
  safehop_enabled     = true
  safehop_retry_count = 2
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
  enabled     = true
  pullzone    = bunnynet_pullzone.zone.id
  description = "Secret extra origin header"

  actions = [
    {
      type       = "SetRequestHeader"
      parameter1 = "Host"
      parameter2 = var.origin_hostname
      parameter3 = null # Must be defined
    },
    {
      type       = "SetRequestHeader"
      parameter1 = var.secret_header_key
      parameter2 = var.secret_header_value
      parameter3 = null # Must be defined
    },
  ]

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
