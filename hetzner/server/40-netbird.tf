resource "netbird_setup_key" "server" {
  count = var.use_netbird ? 1 : 0

  name                   = var.name
  expiry_seconds         = 0
  type                   = "one-off"
  usage_limit            = 1
  allow_extra_dns_labels = true
  ephemeral              = false
  revoked                = false
}
