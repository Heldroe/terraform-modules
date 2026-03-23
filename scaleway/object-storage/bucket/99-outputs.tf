output "id" {
  description = "The bucket ID."
  value       = scaleway_object_bucket.bucket.id
}

output "name" {
  description = "The bucket name (without regional prefix)."
  value       = local.bucket_name
}

output "endpoint" {
  description = "The bucket endpoint."
  value       = scaleway_object_bucket.bucket.endpoint
}

output "region" {
  description = "The bucket region."
  value       = scaleway_object_bucket.bucket.region
}
