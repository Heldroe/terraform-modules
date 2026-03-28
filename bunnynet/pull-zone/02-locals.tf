locals {
  name = var.accelerated_pullzone_id != null ? data.bunnynet_pullzone.zone[0].name : var.name

  send_secret_header = var.secret_header_key != null && var.secret_header_value != null
}
