output "write_user_access_key" {
  description = "Access key for the bucket write user (e.g. CI pipeline)."
  sensitive   = true
  value       = module.write_user.access_key
}

output "write_user_secret_key" {
  description = "Secret key for the bucket write user (e.g. CI pipeline)."
  sensitive   = true
  value       = module.write_user.secret_key
}
