output "service_name" {
  value       = aws_ecs_service.dispute_tools.name
  description = "ECS Service name"
}
