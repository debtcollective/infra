/**
 *efiling_frontend module creates a ECS deployment serving the campaign-api app
 *
 *This module creates a ECS service to run inside a ECS cluster.
 *
 *## Usage:
 *
 *```hcl
 *module "efiling_frontend" {
 *  source      = "../../../../modules/services/efiling_frontend"
 *  environment = local.environment
 *
 *  domain         = aws_route53_record.efiling_frontend.fqdn
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
  container_name = "efiling_frontend"
  container_port = "4200"
  name_prefix    = substr(var.environment, 0, 2)
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "efiling_frontend" {
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
resource "aws_lb_listener_rule" "efiling_frontend" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.efiling_frontend.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "efiling_frontend" {
  family                = "efiling_frontend_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "efiling_frontend" {
  name            = "efiling_frontend"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.efiling_frontend.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.efiling_frontend.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
