/**
 *disputes_api module creates a ECS deployment serving the disputes-api app
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
 *module "disputes_api" {
 *  source      = "../services/disputes_api"
 *  environment = "${var.environment}"
 *  image       = "${var.image}"
 *
 *  key_name                = "${var.key_name}"
 *  iam_instance_profile_id = "${var.iam_instance_profile_id}"
 *  subnet_ids              = ["${var.subnet_ids}"]
 *  security_groups         = ["${var.security_groups}"]
 *  asg_min_size            = "${var.asg_min_size}"
 *  asg_max_size            = "${var.asg_max_size}"
 *
 *  database_url = "${var.database_url}"
 *  introspection = true
 *}
 *```
 */
locals {
  container_name = "disputes_api"
  container_port = "4000"
  name_prefix    = substr(var.environment, 0, 2)
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "disputes_api" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "disputes_api" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.disputes_api.arn}"
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

module "autoscaling" {
  source      = "../../utils/autoscaling"
  environment = var.environment

  cluster_name            = var.ecs_cluster_name
  key_name                = var.key_name
  iam_instance_profile_id = var.iam_instance_profile_id
  security_groups         = var.security_groups
  instance_type           = var.instance_type
  subnet_ids              = var.subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = "disputes_api_${var.environment}"
      propagate_at_launch = true
    },
  ]
}

// Create ECS task definition
resource "aws_ecs_task_definition" "disputes_api" {
  family                = "disputes_api-${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "disputes_api" {
  name            = "disputes_api"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.disputes_api.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.disputes_api.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
