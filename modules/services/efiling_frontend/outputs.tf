output "service_name" {
  value       = aws_ecs_service.efiling_frontend.name
  description = "ECS Service name"
}
