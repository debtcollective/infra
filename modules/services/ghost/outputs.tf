output "service_name" {
  value       = aws_ecs_service.metabase.name
  description = "ECS Service name"
}
