resource "bunnynet_dns_record" "server" {
  count = var.bunnynet_dns_zone_id != null ? 1 : 0

  zone  = var.bunnynet_dns_zone_id
  value = hcloud_server.node.ipv4_address
  name  = ""
  type  = "A"

  accelerated = false
  enabled     = true

  # This checks a non-5xx response on port 80 every 30s (non configurable)
  # See https://support.bunny.net/hc/en-us/articles/7247529148946-Understanding-Bunny-DNS-Monitoring
  monitor_type = "Http"
}
