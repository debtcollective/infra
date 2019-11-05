output "service_name" {
  value       = module.mail_for_good.service_name
  description = "ECS Service name"
}

output "dns_name" {
  value       = module.mail_for_good.dns_name
  description = "ELB dns_name"
}

output "zone_id" {
  value       = module.mail_for_good.zone_id
  description = "ELB zone_id"
}
