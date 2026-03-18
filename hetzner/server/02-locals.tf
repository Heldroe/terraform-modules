locals {
  cluster_label_key = "cluster"

  peers     = [for server in data.hcloud_servers.cluster_peers.servers : server if server.labels.private_ip != var.private_ip]
  peer_ips  = [for peer in local.peers : peer.labels.private_ip]
  peer_host = length(local.peer_ips) > 0 ? local.peer_ips[0] : null

  cluster_token = length(local.peers) > 0 ? local.peers[0].labels.cluster_token : random_password.cluster_token[0].result
}
