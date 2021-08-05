output "service_name" {
  value       = aws_ecs_service.wordpress.name
  description = "ECS Service name"
}
