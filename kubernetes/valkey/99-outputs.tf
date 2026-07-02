output "domain" {
  description = "The created cache domain."
  value       = "${var.release_name}-valkey.${local.namespace}.svc.cluster.local"
}
