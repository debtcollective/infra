output "service_name" {
  value       = aws_ecs_service.campaign_api.name
  description = "ECS Service name"
}
