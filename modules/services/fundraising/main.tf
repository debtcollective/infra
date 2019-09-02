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
 *  db_password = "${var.db_password}"
 *  db_host     = "${var.db_host}"
 *  db_port     = "${var.db_port}"
 *  db_name     = "${var.db_name}"
 *
 *  key_name                = "${var.key_name}"
 *  iam_instance_profile_id = "${var.iam_instance_profile_id}"
 *  subnet_ids              = ["${var.subnet_ids}"]
 *  security_groups         = ["${var.security_groups}"]
 *  asg_min_size            = "${var.asg_min_size}"
 *  asg_max_size            = "${var.asg_max_size}"
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
data "aws_acm_certificate" "domain" {
  domain   = var.acm_certificate_domain
  statuses = ["ISSUED"]
}

resource "aws_lb" "fundraising" {
  name_prefix     = local.name_prefix
  security_groups = var.elb_security_groups
  subnets         = var.subnet_ids
}

resource "aws_lb_target_group" "fundraising" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "fundraising_http" {
  load_balancer_arn = aws_lb.fundraising.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.fundraising.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "fundraising_https" {
  load_balancer_arn = aws_lb.fundraising.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.domain.arn
  ssl_policy        = "ELBSecurityPolicy-2015-05"

  default_action {
    target_group_arn = aws_lb_target_group.fundraising.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.fundraising_http.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = [var.acm_certificate_domain]
  }
}

module "autoscaling" {
  source      = "../../utils/autoscaling"
  environment = var.environment

  cluster_name            = aws_ecs_cluster.fundraising.name
  key_name                = var.key_name
  iam_instance_profile_id = var.iam_instance_profile_id
  security_groups         = var.security_groups
  instance_type           = var.instance_type
  subnet_ids              = var.subnet_ids
}

resource "aws_cloudwatch_log_group" "fundraising" {
  name = "${var.environment}-fundraising-lg"

  tags = {
    Environment = var.environment
    Application = "fundraising"
    Terraform   = true
  }
}

module "container_definitions" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.15.0"

  container_name               = local.container_name
  container_cpu                = 0
  container_memory             = 0
  container_memory_reservation = 479
  essential                    = true
  container_image              = var.container_image

  environment = [
    {
      name  = "RAILS_ENV",
      value = "staging"
    },
    {
      name  = "DATABASE_URL",
      value = var.database_url
    }
  ]

  port_mappings = [
    {
      containerPort = local.container_port
    }
  ]

  log_driver = "awslogs"
  log_options = {
    "awslogs-region" = data.aws_region.current.name
    "awslogs-group"  = aws_cloudwatch_log_group.fundraising.name
  }
}

// Create ECS cluster
resource "aws_ecs_cluster" "fundraising" {
  name = "fundraising-${var.environment}"
}

// Create ECS task definition
resource "aws_ecs_task_definition" "fundraising" {
  family                = "fundraising-${var.environment}"
  container_definitions = module.container_definitions.json
}

// Create ECS service
resource "aws_ecs_service" "fundraising" {
  name            = "fundraising-${var.environment}"
  cluster         = aws_ecs_cluster.fundraising.id
  task_definition = aws_ecs_task_definition.fundraising.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.fundraising.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
