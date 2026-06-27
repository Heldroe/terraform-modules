output "kubernetes_pull_username" {
  description = "Generated Kubernetes pull credentials username."
  sensitive   = true
  value       = local.kubernetes_pull_user
}

output "kubernetes_pull_password" {
  description = "Generated Kubernetes pull credentials password."
  sensitive   = true
  value       = random_password.kubernetes_pull.result
}
