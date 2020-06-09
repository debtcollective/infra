output "service_name" {
  value       = aws_ecs_service.ghost.name
  description = "ECS Service name"
}
