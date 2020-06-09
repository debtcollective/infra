locals {
  container_name = "ghost"
  container_port = 2368
  name_prefix    = "gh-${substr(var.environment, 0, 2)}-"

}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "ghost" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "ghost" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ghost.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "ghost" {
  family                = "ghost_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "ghost" {
  name            = "ghost"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ghost.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.ghost.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
