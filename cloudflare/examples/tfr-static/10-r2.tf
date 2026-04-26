resource "cloudflare_r2_bucket" "registry" {
  account_id = var.cloudflare_account_id
  name       = var.bucket_name
  location   = var.bucket_location
}

resource "cloudflare_r2_custom_domain" "registry_domain" {
  account_id  = var.cloudflare_account_id
  zone_id     = var.cloudflare_zone_id
  domain      = var.registry_domain
  bucket_name = cloudflare_r2_bucket.registry.name
  enabled     = true
}
