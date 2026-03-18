output "private_ip" {
  description = "Private IP of the server."
  value       = var.private_ip
}

output "cluster_token" {
  description = "Secret k3s cluster token to join the cluster."
  sensitive   = true
  value       = local.cluster_token
}

output "peers_ips" {
  description = "Peer IPs fetched as candidates for k3s initialization."
  value       = local.peer_ips
}

output "peer_host" {
  description = "Peer host used for k3s initialization."
  value       = local.peer_host
}
