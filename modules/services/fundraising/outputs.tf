output "service_name" {
  value       = aws_ecs_service.fundraising.name
  description = "ECS Service name"
}
