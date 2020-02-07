/**
 *Cluster module creates a ECS cluster and a ALB to be used by apps and services in a specific environment
 *The cluster is created inside a VPC.
 *
 *This module creates all the necessary pieces that are needed to run a cluster, including:
 *
 ** ECS Cluster
 ** Application load balancer (ALB)
 *
 *## Usage:
 *
 *```hcl
 *module "cluster" {
 *  source      = "../cluster"
 *  environment = "${var.environment}"
 *
 *  security_groups_ids = var.security_groups
 *  subnet_ids = var.subnet_ids
 *}
 *```
 */
locals {
  alb_name = "${var.environment}-alb"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.environment

  setting {
    name  = "containerInsights"
    value = var.monitoring == true ? "enabled" : "disabled"
  }
}

resource "aws_lb" "lb" {
  name            = local.alb_name
  security_groups = var.security_group_ids
  subnets         = var.subnet_ids

  tags = {
    Environment = var.environment
    Terraform   = true
  }
}

// SSL certificate
data "aws_acm_certificate" "domain" {
  domain   = var.acm_certificate_domain
  statuses = ["ISSUED"]
}


// This is the default HTTP listener
// We assume all routes will serve HTTPS and redirect there
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.id
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

// This is the default HTTPS listener
// Users shouldn't reach this route
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.domain.arn
  ssl_policy        = "ELBSecurityPolicy-2015-05"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Here Be Dragons."
      status_code  = "200"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_usage" {
  count = var.monitoring == true ? 1 : 0

  alarm_name          = "${var.environment}-cluster-high-cpu-usage"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_actions = [var.slack_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "high_memory_usage" {
  count = var.monitoring == true ? 1 : 0

  alarm_name          = "${var.environment}-cluster-high-memory-usage"
  alarm_description   = "This metric monitors ec2 memory utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_actions = [var.slack_topic_arn]
}
