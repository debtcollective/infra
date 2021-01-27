locals {
  container_name = "chatwoot"
  container_port = 3000
  name_prefix    = "cw-${substr(var.environment, 0, 2)}-"

}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "chatwoot" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval = 120
    timeout  = 60
    matcher  = "200-299"
    path     = "/"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "chatwoot" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chatwoot.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "chatwoot" {
  family                = "chatwoot_${var.environment}"
  container_definitions = "[${module.container_definition_app.json_map},${module.container_definition_workers.json_map}]"
}

// Create ECS service
resource "aws_ecs_service" "chatwoot" {
  name            = "chatwoot"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.chatwoot.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.chatwoot.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
