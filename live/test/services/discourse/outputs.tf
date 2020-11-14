output "public_ip" {
  value       = module.discourse.public_ip
  description = "Instance public ip"
}

output "domain" {
  value       = aws_route53_record.discourse.fqdn
  description = "Domain name"
}

output "sso_cookie_name" {
  value       = module.discourse.sso_cookie_name
  description = "SSO cookie name"
}

output "uploads_bucket_arn" {
  value       = aws_s3_bucket.uploads.arn
  description = "Uploads bucket ARN"
}

output "uploads_bucket_name" {
  value       = aws_s3_bucket.uploads.id
  description = "Uploads bucket name"
}

output "backups_bucket_arn" {
  value       = aws_s3_bucket.backups.arn
  description = "Backups bucket ARN"
}

output "backups_bucket_name" {
  value       = aws_s3_bucket.backups.id
  description = "Backups bucket name"
}
