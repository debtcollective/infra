output "public_ip" {
  description = "Bastion Public Ip"
  value       = aws_eip.bastion_eip.public_ip
}
