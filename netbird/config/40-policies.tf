resource "netbird_policy" "clients_to_cluster" {
  name    = "Clients to clusters access"
  enabled = true

  rule {
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "tcp"
    port_ranges = [
      {
        start = 80
        end   = 80
      },
      {
        start = 443
        end   = 65535
      },
    ]
    name         = "Clients to clusters access"
    sources      = [for group in var.client_groups : netbird_group.group[group].id]
    destinations = [for group in keys(var.remote_cluster_groups) : netbird_group.group[group].id]
  }
}
