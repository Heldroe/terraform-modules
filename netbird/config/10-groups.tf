resource "netbird_group" "group" {
  for_each = local.all_groups

  name = each.key
}
