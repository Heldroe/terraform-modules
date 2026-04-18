output "arn" {
  description = "The zone ARN."
  value       = aws_route53_zone.primary.arn
}

output "id" {
  description = "The zone ID."
  value       = aws_route53_zone.primary.zone_id
}

output "name_servers" {
  description = "The zone's name servers."
  value       = aws_route53_zone.primary.name_servers
}
