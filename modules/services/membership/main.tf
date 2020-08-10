/**
 *Membership module creates a ECS deployment with Membership app docker image
 *The cluster is created inside a VPC.
 *
 *This module creates all the necessary pieces that are needed to run a service inside the provided cluster
 */
locals {
  container_name = "membership"
  container_port = "5000"
  name_prefix    = "fr-${substr(var.environment, 0, 2)}-"
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "membership" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health-check"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "membership" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.membership.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "membership" {
  family                = "membership_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "membership" {
  name            = "membership"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.membership.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.membership.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
