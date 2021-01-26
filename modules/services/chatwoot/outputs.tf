output "service_name" {
  value       = aws_ecs_service.chatwoot.name
  description = "ECS Service name"
}
