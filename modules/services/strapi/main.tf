locals {
  container_name = "strapi"
  container_port = 1337
  name_prefix    = "mb-${substr(var.environment, 0, 2)}-"

}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "strapi" {
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
resource "aws_lb_listener_rule" "strapi" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "strapi" {
  family                = "strapi_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "strapi" {
  name            = "strapi"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
