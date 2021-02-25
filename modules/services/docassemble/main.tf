/**
 *Membership module creates a ECS deployment with Membership app docker image
 *The cluster is created inside a VPC.
 *
 *This module creates all the necessary pieces that are needed to run a service inside the provided cluster
 */
locals {
  container_name = "docassemble"
  container_port = "80"
  name_prefix    = "fr-${substr(var.environment, 0, 2)}-"
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "docassemble" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval = 120
    timeout  = 60
    matcher  = "200"
    path     = "/"
  }


  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "docassemble" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docassemble.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "docassemble" {
  family                = "docassemble_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "docassemble" {
  name            = "docassemble"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.docassemble.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.docassemble.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }

  lifecycle {
    create_before_destroy = true
  }
}
