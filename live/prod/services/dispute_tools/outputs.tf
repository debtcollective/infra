output "service_name" {
  value       = module.dispute_tools.service_name
  description = "ECS Service name"
}

output "uploads_bucket_arn" {
  value       = aws_s3_bucket.disputes.arn
  description = "Uploads bucket ARN"
}

output "uploads_bucket_name" {
  value       = aws_s3_bucket.disputes.id
  description = "Uploads bucket name"
}
