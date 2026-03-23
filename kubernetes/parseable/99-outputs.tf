output "admin_username" {
  description = "The default admin username."
  sensitive   = true
  value       = var.admin_username
}

output "admin_password" {
  description = "The default admin password."
  sensitive   = true
  value       = local.admin_password
}
