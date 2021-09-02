output "service_name" {
  value       = aws_ecs_service.directus.name
  description = "ECS Service name"
}
