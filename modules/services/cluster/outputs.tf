output "lb_id" {
  description = "ALB id"
  value       = aws_lb.lb.id
}

output "lb_arn_suffix" {
  description = "ALB arn suffix for use with CloudWatch Metrics"
  value       = aws_lb.lb.id
}

output "lb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.lb.dns_name
}

output "lb_zone_id" {
  description = "ALB canonical hosted zone ID, to be used in a Route 53 Alias record"
  value       = aws_lb.lb.dns_name
}

output "cluster_id" {
  description = "ECS cluster ID/ARN"
  value       = aws_ecs_cluster.cluster.id
}
