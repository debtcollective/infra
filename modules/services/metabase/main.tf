locals {
  container_name = "metabase"
  container_port = 3000
  name_prefix    = "mb-${substr(var.environment, 0, 2)}-"

}

// Load balancer
resource "aws_lb_target_group" "metabase" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/api/health"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "metabase" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "metabase" {
  family                = "metabase_${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "metabase" {
  name            = "metabase-${var.environment}"
  cluster         = aws_ecs_cluster.metabase.id
  task_definition = aws_ecs_task_definition.metabase.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.metabase.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
