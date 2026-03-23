output "id" {
  description = "Application ID"
  value       = scaleway_iam_application.application.id
}

output "access_key" {
  description = "Application access key ID."
  sensitive   = true
  value       = scaleway_iam_api_key.key.access_key
}

output "secret_key" {
  description = "Application secret key."
  sensitive   = true
  value       = scaleway_iam_api_key.key.secret_key
}
