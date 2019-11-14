output "service_name" {
  value       = aws_ecs_service.disputes_api.name
  description = "ECS Service name"
}
