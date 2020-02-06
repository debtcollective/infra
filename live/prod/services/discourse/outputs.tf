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
