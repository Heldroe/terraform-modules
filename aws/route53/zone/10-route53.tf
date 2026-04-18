resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "mx" {
  for_each = var.mx_records

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.key
  type    = "MX"
  ttl     = 300
  records = each.value
}

resource "aws_route53_record" "txt" {
  for_each = var.txt_records

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.key
  type    = "TXT"
  ttl     = 300
  records = each.value
}
