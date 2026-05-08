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
  value       = "https://${local.regional_endpoint_domain}"
}

output "regional_endpoint_domain" {
  description = "The bucket regional endpoint domain (without the bucket name)."
  value       = local.regional_endpoint_domain
}

output "region" {
  description = "The bucket region."
  value       = var.region # Outputting the scaleway_object_bucket.bucket value directly is unreliable
}
