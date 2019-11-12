/**
 *Fundraising module creates a ECS deployment with Fundraising app docker image
 *The cluster is created inside a VPC.
 *
 *This module creates all the necessary pieces that are needed to run a cluster, including:
 *
 ** Auto Scaling Groups
 ** EC2 Launch Configurations
 ** Application load balancer (ELB)
 *
 *## Usage:
 *
 *```hcl
 *module "fundraising" {
 *  source      = "../services/fundraising"
 *  environment = "${var.environment}"
 *  image       = "${var.image}"
 *
 *  db_username = "${var.db_username}"
 *  db_pass     = "${var.db_pass}"
 *  db_host     = "${var.db_host}"
 *  db_port     = "${var.db_port}"
 *  db_name     = "${var.db_name}"
 *}
 *```
 */
locals {
  container_name = "fundraising"
  container_port = "5000"
  name_prefix    = "fr-${substr(var.environment, 0, 2)}-"
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "fundraising" {
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
resource "aws_lb_listener_rule" "fundraising" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fundraising.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "fundraising" {
  family                = "fundraising-${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "fundraising" {
  name            = "fundraising"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.fundraising.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.fundraising.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
