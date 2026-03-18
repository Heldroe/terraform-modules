resource "tailscale_tailnet_key" "key" {
  count = var.use_tailscale ? 1 : 0

  reusable      = false
  ephemeral     = false
  preauthorized = true
  expiry        = 600 # Expire after 10m
}

# Disable key expiry for new server
resource "tailscale_device_key" "server" {
  count = var.use_tailscale && var.disable_tailscale_key_expiry ? 1 : 0

  device_id           = data.tailscale_device.server[0].id
  key_expiry_disabled = true
}
