output "public_ip" {
  description = "Bastion Public Ip"
  value       = module.bastion.public_ip
}
