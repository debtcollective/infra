output "public_ip" {
  value       = aws_eip.discourse.public_ip
  description = "Instance public ip"
}
