resource "hcloud_zone" "zone" {
  name = var.name
  mode = "primary"
}
