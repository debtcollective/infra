output "service_name" {
  value       = "${aws_ecs_service.disputes_api.name}"
  description = "ECS Service name"
}

output "dns_name" {
  value       = "${aws_lb.disputes_api.dns_name}"
  description = "ALB dns_name"
}

output "zone_id" {
  value       = "${aws_lb.disputes_api.zone_id}"
  description = "ALB zone_id"
}
