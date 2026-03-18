resource "hcloud_placement_group" "placement" {
  name = var.name
  type = "spread"
}
