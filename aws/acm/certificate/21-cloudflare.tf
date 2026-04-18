resource "cloudflare_dns_record" "cloudfront" {
  for_each = var.cloudflare_zone_id != null ? {
    for dvo in distinct([
      for dvo in aws_acm_certificate.certificate.domain_validation_options : {
        name   = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
      }
    ]) : dvo.name => dvo
  } : {}

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.record
  ttl     = 60

  comment = "ACM certificate validation for ${var.domain_name}"
  proxied = false
}
