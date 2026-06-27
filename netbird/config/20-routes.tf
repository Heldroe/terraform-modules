resource "netbird_route" "private_ingress" {
  for_each = var.remote_cluster_groups

  network_id  = "${each.key} private ingress"
  groups      = [for client_group in var.client_groups : netbird_group.group[client_group].id]
  peer_groups = [netbird_group.group[each.key].id]
  description = "Private ingress IPs for ${each.key}"
  network     = "${each.value.private_ingress_ip}/32"

  access_control_groups = [for client_group in var.client_groups : netbird_group.group[client_group].id]
}

resource "netbird_route" "private_ingress_domain" {
  for_each = var.remote_cluster_groups

  network_id  = "${each.key} private ingress domain"
  groups      = [for client_group in var.client_groups : netbird_group.group[client_group].id]
  peer_groups = [netbird_group.group[each.key].id]
  description = "Private ingress IPs for ${each.key}"
  domains = [
    each.value.private_ingress_domain,
    "*.${each.value.private_ingress_domain}",
  ]

  access_control_groups = [for group in keys(var.remote_cluster_groups) : netbird_group.group[group].id]
}

resource "netbird_route" "kubernetes_api" {
  for_each = var.remote_cluster_groups

  network_id  = "${each.key} Kubernetes API"
  groups      = [for client_group in var.client_groups : netbird_group.group[client_group].id]
  peer_groups = [netbird_group.group[each.key].id]
  description = "Kubernetes API IP for ${each.key}"
  network     = "${each.value.kubernetes_api_ip}/32"

  access_control_groups = [for client_group in var.client_groups : netbird_group.group[client_group].id]
}
