output "service_name" {
  value       = "${module.disputes_api.service_name}"
  description = "ECS Service name"
}

output "dns_name" {
  value       = "${module.disputes_api.dns_name}"
  description = "ELB dns_name"
}

output "zone_id" {
  value       = "${module.disputes_api.zone_id}"
  description = "ELB zone_id"
}
