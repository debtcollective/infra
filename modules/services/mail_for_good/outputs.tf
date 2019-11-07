output "service_name" {
  value       = "${aws_ecs_service.mail_for_good.name}"
  description = "ECS Service name"
}

output "dns_name" {
  value       = "${aws_lb.mail_for_good.dns_name}"
  description = "ALB dns_name"
}

output "zone_id" {
  value       = "${aws_lb.mail_for_good.zone_id}"
  description = "ALB zone_id"
}
