output "parameter_arn" {
  description = "The SSM parameter ARN."
  value       = aws_ssm_parameter.parameter.arn
}

output "parameter_name" {
  description = "The SSM parameter name."
  value       = var.name
}

output "iam_policy_write_arn" {
  description = "The IAM policy ARN allowing write access to the SSM parameter."
  value       = aws_iam_policy.write.arn
}

output "iam_policy_read_arn" {
  description = "The IAM policy ARN allowing read access to the SSM parameter."
  value       = aws_iam_policy.read.arn
}

output "aws_region" {
  description = "The current AWS region."
  value       = data.aws_region.current.region
}
