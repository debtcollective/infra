locals {
  container_name = "directus"
  container_port = 8055
  name_prefix    = "mb-${substr(var.environment, 0, 2)}-"

}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "directus" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 300
    matcher             = "200-299,300-399"
    path                = "/"
    timeout             = 120
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "directus" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.directus.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "directus" {
  family                = "directus_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "directus" {
  name            = "directus"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.directus.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.directus.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
