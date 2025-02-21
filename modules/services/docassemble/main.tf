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
resource "aws_ecs_task_definition" "backend" {
  family                = "docassemble_backend_${var.environment}"
  container_definitions = "[${module.container_definition_backend.json_map}]"
}
resource "aws_ecs_task_definition" "app" {
  family                = "docassemble_app_${var.environment}"
  container_definitions = "[${module.container_definition_app.json_map}]"
}

// Create ECS service
resource "aws_ecs_service" "backend" {
  name            = "docassemble-backend-${var.environment}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
}

resource "aws_ecs_service" "app" {
  name            = "docassemble-app-${var.environment}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2

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
    debug               = var.debug
    landing_url         = var.landing_url
    secretkey           = var.secretkey
    mail_cc             = var.mail_cc
    mail_email_zapier   = var.mail_email_zapier
    mail_lawyer         = var.mail_lawyer
    mail_lawyer_bail    = var.mail_lawyer_bail
    mail_lawyer_student = var.mail_lawyer_student
    server_admin_email  = var.server_admin_email
    voicerss_key        = var.voicerss_key
    rabbitmq            = var.rabbitmq
    domain              = var.domain
    default_interview   = var.default_interview
    pythonpackages      = split(";", var.pythonpackages)

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

    mailgun_api_url = var.mailgun_api_url
    mailgun_api_key = var.mailgun_api_key
    mailgun_domain  = var.mailgun_domain
    default_sender  = var.default_sender
  })
}
