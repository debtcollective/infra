output "service_name" {
  value       = aws_ecs_service.strapi.name
  description = "ECS Service name"
}
