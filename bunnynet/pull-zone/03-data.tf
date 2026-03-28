data "bunnynet_pullzone" "zone" {
  count = var.accelerated_pullzone_id != null ? 1 : 0

  id = var.accelerated_pullzone_id
}
