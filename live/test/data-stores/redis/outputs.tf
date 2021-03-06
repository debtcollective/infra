output "id" {
  value       = module.redis.id
  description = "Redis cluster ID"
}

output "security_group_id" {
  value       = module.redis.security_group_id
  description = "Redis security group ID"
}

output "port" {
  value       = module.redis.port
  description = "Redis port"
}

output "host" {
  value       = module.redis.host
  description = "Redis host"
}

output "endpoint" {
  value       = module.redis.endpoint
  description = "Redis endpoint"
}
