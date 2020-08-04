output "service_name" {
  value       = aws_ecs_service.membership.name
  description = "ECS Service name"
}
