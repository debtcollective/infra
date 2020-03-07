locals {
  container_name = "dispute_tools"
  container_port = "8080"
  name_prefix    = substr(var.environment, 0, 2)
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "dispute_tools" {
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
resource "aws_lb_listener_rule" "dispute_tools" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dispute_tools.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "dispute_tools" {
  family                = "dispute_tools_${var.environment}"
  container_definitions = "[${module.container_definition_app.json_map},${module.container_definition_workers.json_map}]"
}

// Create ECS service
resource "aws_ecs_service" "dispute_tools" {
  name            = "dispute_tools"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.dispute_tools.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.dispute_tools.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
