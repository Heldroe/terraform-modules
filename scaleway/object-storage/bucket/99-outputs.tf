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

output "regional_endpoint" {
  description = "The bucket regional endpoint (without the bucket name)."
  value       = "https://s3.${var.region}.scw.cloud"
}

output "region" {
  description = "The bucket region."
  value       = var.region # Outputting the scaleway_object_bucket.bucket value directly is unreliable
}
