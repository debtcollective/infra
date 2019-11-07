output "lb_id" {
  description = "ALB id"
  value       = module.cluster.lb_id
}

output "lb_arn_suffix" {
  description = "ALB arn suffix for use with CloudWatch Metrics"
  value       = module.cluster.lb_arn_suffix
}

output "lb_dns_name" {
  description = "ALB DNS name"
  value       = module.cluster.lb_dns_name
}

output "lb_zone_id" {
  description = "ALB canonical hosted zone ID, to be used in a Route 53 Alias record"
  value       = module.cluster.lb_zone_id
}

output "cluster_id" {
  description = "ECS cluster ID/ARN"
  value       = module.cluster.cluster_id
}
