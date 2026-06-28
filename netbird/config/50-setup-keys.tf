resource "netbird_setup_key" "key" {
  for_each = var.setup_keys

  name                   = each.key
  expiry_seconds         = each.value.expiry_seconds
  type                   = each.value.type
  allow_extra_dns_labels = each.value.allow_extra_dns_labels
  auto_groups            = [for group in each.value.groups : netbird_group.group[group].id]
  ephemeral              = each.value.ephemeral
  revoked                = false
  usage_limit            = each.value.usage_limit
}
