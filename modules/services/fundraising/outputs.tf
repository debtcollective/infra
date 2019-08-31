output "service_name" {
  value       = "${aws_ecs_service.fundraising.name}"
  description = "ECS Service name"
}

output "dns_name" {
  value       = "${aws_lb.fundraising.dns_name}"
  description = "ALB dns_name"
}

output "zone_id" {
  value       = "${aws_lb.fundraising.zone_id}"
  description = "ALB zone_id"
}
