output "groups" {
  description = "Created NetBird groups."
  value       = { for group_name in local.all_groups : group_name => netbird_group.group[group_name].id }
}

output "setup_keys" {
  description = "Created setup keys."
  sensitive   = true
  value = {
    for name, key in var.setup_keys : name => {
      id  = netbird_setup_key.key[name].id
      key = netbird_setup_key.key[name].key
    }
  }
}
