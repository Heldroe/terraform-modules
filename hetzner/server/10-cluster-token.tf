resource "random_password" "cluster_token" {
  count = length(local.peers) > 0 ? 0 : 1

  length  = 32
  special = false # Avoid potential bash complications
}
