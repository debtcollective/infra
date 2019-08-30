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
 *  db_name     = "${var.metabase_db_name}"
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
  name_prefix    = "fundraising-${substr(var.environment, 0, 2)}-"
}

// Load balancer
data "aws_acm_certificate" "domain" {
  domain   = var.acm_certificate_domain
  statuses = ["ISSUED"]
}

resource "aws_lb" "fundraising" {
  name_prefix     = local.name_prefix
  security_groups = [var.elb_security_groups]
  subnets         = [var.subnet_ids]
}

resource "aws_lb_target_group" "fundraising" {
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

resource "aws_lb_listener" "metabase_http" {
  load_balancer_arn = aws_lb.fundraising.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.fundraising.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "metabase_https" {
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
  listener_arn = aws_lb_listener.metabase_http.arn

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

data "template_file" "fundraising" {
  template = file("${path.module}/container-definitions.json")

  vars {
    container_name = local.container_name
    image          = var.image

    db_username = var.db_username
    db_password = var.db_password
    db_host     = var.db_host
    db_port     = var.db_port
    db_name     = var.db_name
  }
}

module "autoscaling" {
  source      = "../../../utils/autoscaling"
  environment = var.environment

  cluster_name            = aws_ecs_cluster.fundraising.name
  key_name                = var.key_name
  iam_instance_profile_id = var.iam_instance_profile_id
  security_groups         = [var.security_groups]
  instance_type           = var.instance_type
  subnet_ids              = [var.subnet_ids]
}

resource "aws_autoscaling_group" "metabase_asg" {
  launch_configuration = module.metabase_lc.id
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  health_check_type    = "ELB"
  vpc_zone_identifier  = [var.subnet_ids]
}

// Create ECS cluster
resource "aws_ecs_cluster" "fundraising" {
  name = "fundraising-c-${var.environment}"
}

// Create ECS task definition
resource "aws_ecs_task_definition" "fundraising" {
  family                = "fundraising-${var.environment}"
  container_definitions = data.template_file.metabase.rendered
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
    container_port   = "3000"
  }
}
