output "name" {
  description = "The user's name."
  value       = aws_iam_user.user.name
}

output "access_key_id" {
  description = "The user's access key ID."
  value       = aws_iam_access_key.key.id
}

output "access_key_secret" {
  description = "The user's access key secret."
  sensitive   = true
  value       = aws_iam_access_key.key.secret
}
