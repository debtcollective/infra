/**
 *Membership module creates a ECS deployment with Membership app docker image
 *The cluster is created inside a VPC.
 *
 *This module creates all the necessary pieces that are needed to run a service inside the provided cluster
 */
locals {
  container_name         = "docassemble"
  app_container_name     = "${local.container_name}-app"
  backend_container_name = "${local.container_name}-backend"
  container_port         = "80"
  name_prefix            = "fr-${substr(var.environment, 0, 2)}-"
}

data "aws_region" "current" {}

// Load balancer
resource "aws_lb_target_group" "docassemble" {
  name_prefix = local.name_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 300
    matcher             = "200"
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
resource "aws_lb_listener_rule" "docassemble" {
  listener_arn = var.lb_listener_id

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docassemble.arn
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

// Create ECS task definition
resource "aws_ecs_task_definition" "docassemble" {
  family                = "docassemble_${var.environment}"
  container_definitions = "[${module.container_definition_app.json_map},${module.container_definition_backend.json_map}]"
}

// Create ECS service
resource "aws_ecs_service" "docassemble" {
  name            = "docassemble"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.docassemble.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.docassemble.arn
    container_name   = local.app_container_name
    container_port   = local.container_port
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Upload config to S3 bucket
resource "aws_s3_bucket_object" "object" {
  bucket = var.s3_bucket
  key    = "config.yml"
  content = templatefile("${path.module}/config.yml", {
    debug             = var.debug
    landing_url       = var.landing_url
    secretkey         = var.secretkey
    timezone          = var.timezone
    domain            = var.domain
    default_interview = var.default_interview
    pythonpackages    = split(";", var.pythonpackages)

    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
    db_host     = var.db_host
    db_port     = var.db_port

    s3_bucket            = var.s3_bucket
    s3_access_key_id     = var.s3_access_key_id
    s3_secret_access_key = var.s3_secret_access_key
    s3_region            = var.s3_region

    redis_url = var.redis_url

    smtp_username = var.smtp_username
    smtp_password = var.smtp_password
    smtp_host     = var.smtp_host
    smtp_port     = var.smtp_port
    smtp_port     = var.smtp_port
    mail_from     = var.mail_from
    mail_lawyer   = var.mail_lawyer
    mail_cc       = var.mail_cc
  })
}
