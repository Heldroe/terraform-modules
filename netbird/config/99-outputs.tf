output "groups" {
  description = "Created NetBird groups."
  value       = { for group_name in local.all_groups : group_name => netbird_group.group[group_name].id }
}
