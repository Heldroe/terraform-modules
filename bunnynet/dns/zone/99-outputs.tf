output "domain" {
  description = "DNS zone domain name."
  value       = var.domain
}

output "zone_id" {
  description = "DNS zone ID."
  value       = bunnynet_dns_zone.zone.id
}
# test
