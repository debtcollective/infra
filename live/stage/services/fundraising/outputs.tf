output "service_name" {
  value       = "${module.fundraising.service_name}"
  description = "ECS Service name"
}

output "dns_name" {
  value       = "${module.fundraising.dns_name}"
  description = "ELB dns_name"
}

output "zone_id" {
  value       = "${module.fundraising.zone_id}"
  description = "ELB zone_id"
}
