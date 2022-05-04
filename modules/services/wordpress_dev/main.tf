locals {
  container_name = "wordpress_dev"
  container_port = 80
  name_prefix    = "wp-de-"

}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "wordpress_dev" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 120
    matcher             = "200-299,300-399"
    path                = "/"
    timeout             = 60
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Services only should define this to work correctly
resource "aws_lb_listener_rule" "wordpress_dev" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_dev.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "wordpress_dev" {
  family                = "wordpress_dev"
  container_definitions = module.container_definitions.json
  execution_role_arn    = var.execution_role_arn
  volume {
    name = "efs-wordpress-data-dev"
    host_path = "/mnt/efs/wordpress_dev"
  }
}

// Create ECS service
resource "aws_ecs_service" "wordpress_dev" {
  name            = "wordpress_dev"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.wordpress_dev.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.wordpress_dev.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}

// Create EFS
resource "aws_efs_file_system" "wordpress-data-dev" {
  creation_token = "es-persistent-data-dev"
  performance_mode = "generalPurpose"

  tags = {
    Name = "wordpress-data-dev"
  }
}

resource "aws_efs_mount_target" "wordpress_dev" {
  count           = length(var.subnet_id)
  file_system_id  = aws_efs_file_system.wordpress-data-dev.id
  subnet_id       = element(var.subnet_id, count.index)
  security_groups = [var.ec2_security_group_id]
}
