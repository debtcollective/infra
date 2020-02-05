output "public_ip" {
  value       = aws_eip.discourse.public_ip
  description = "Instance public ip"
}

output "sso_cookie_name" {
  value       = var.discourse_sso_cookie_name
  description = "SSO cookie name"
}
