/**
 *campaign_api module creates a ECS deployment serving the campaign-api app
 *
 *This module creates a ECS service to run inside a ECS cluster.
 *
 *## Usage:
 *
 *```hcl
 *module "campaign_api" {
 *  source      = "../../../../modules/services/campaign_api"
 *  environment = local.environment
 *
 *  domain         = aws_route53_record.campaign_api.fqdn
 *  ecs_cluster_id = local.ecs_cluster_id
 *  lb_listener_id = local.lb_listener_id
 *  vpc_id         = local.vpc_id
 *
 *  database_url  = local.database_url
 *  introspection = local.introspection
 *}
 *```
 */
locals {
  container_name = "campaign_api"
  container_port = "4000"
  name_prefix    = substr(var.environment, 0, 2)
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "campaign_api" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/.well-known/apollo/server-health"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "campaign_api" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.campaign_api.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "campaign_api" {
  family                = "campaign_api_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "campaign_api" {
  name            = "campaign_api"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.campaign_api.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.campaign_api.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
