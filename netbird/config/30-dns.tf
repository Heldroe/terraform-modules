resource "netbird_dns_zone" "kubernetes_api" {
  for_each = var.remote_cluster_groups

  name                 = "${each.key}-kubernetes-api"
  domain               = "api.${each.key}"
  enabled              = true
  enable_search_domain = false
  distribution_groups  = [for group_name in var.client_groups : netbird_group.group[group_name].id]
}

resource "netbird_dns_record" "kubernetes_api" {
  for_each = var.remote_cluster_groups

  zone_id = netbird_dns_zone.kubernetes_api[each.key].id
  name    = "api.${each.key}"
  type    = "A"
  content = each.value.kubernetes_api_ip
  ttl     = 300
}

resource "netbird_dns_zone" "private_ingress" {
  for_each = var.remote_cluster_groups

  name                 = "${each.key}-private-ingress"
  domain               = each.value.private_ingress_domain
  enabled              = true
  enable_search_domain = false
  distribution_groups  = [for group_name in var.client_groups : netbird_group.group[group_name].id]
}

resource "netbird_dns_record" "private_ingress" {
  for_each = var.remote_cluster_groups

  zone_id = netbird_dns_zone.private_ingress[each.key].id
  name    = "*.${each.value.private_ingress_domain}"
  type    = "A"
  content = each.value.private_ingress_ip
  ttl     = 300
}
