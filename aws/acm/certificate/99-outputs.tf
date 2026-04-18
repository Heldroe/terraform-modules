output "arn" {
  description = "The ACM certificate ARN."
  value       = aws_acm_certificate.certificate.arn
}
