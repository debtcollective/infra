resource "aws_cloudwatch_log_group" "mail_for_good" {
  name = "/${var.environment}/services/mail_for_good"

  tags = {
    Environment = var.environment
    Application = "mail_for_good"
    Terraform   = true
  }
}

resource "random_string" "encryption_password" {
  length  = 48
  special = false
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
      name  = "NODE_ENV",
      value = "production"
    },
    {
      name  = "DOMAIN",
      value = var.domain
    },
    {
      name  = "GOOGLE_CONSUMER_KEY",
      value = var.google_consumer_key
    },
    {
      name  = "GOOGLE_CONSUMER_SECRET",
      value = var.google_consumer_secret
    },
    {
      name  = "GOOGLE_CALLBACK",
      value = "${var.domain}${var.google_callback}"
    },
    {
      name  = "AMAZON_ACCESS_KEY_ID",
      value = var.amazon_access_key_id
    },
    {
      name  = "AMAZON_SECRET_ACCESS_KEY",
      value = var.amazon_secret_access_key
    },
    {
      name  = "PSQL_HOST",
      value = var.db_host
    },
    {
      name  = "PSQL_USERNAME",
      value = var.db_user
    },
    {
      name  = "PSQL_PASSWORD",
      value = var.db_pass
    },
    {
      name  = "PSQL_DATABASE",
      value = var.db_name
    },
    {
      name  = "REDIS_HOST",
      value = var.redis_host
    },
    {
      name  = "REDIS_PORT",
      value = var.redis_port
    },
    {
      name  = "ENCRYPTION_PASSWORD",
      value = random_string.encryption_password.result
    },
  ]

  port_mappings = [
    {
      containerPort = local.container_port
    }
  ]

  log_driver = "awslogs"
  log_options = {
    "awslogs-region" = data.aws_region.current.name
    "awslogs-group"  = aws_cloudwatch_log_group.mail_for_good.name
  }
}
