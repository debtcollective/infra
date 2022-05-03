output "service_name" {
  value       = aws_ecs_service.wordpress_dev.name
  description = "ECS Service name"
}
