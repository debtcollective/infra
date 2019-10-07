resource "aws_cloudwatch_log_group" "fundraising" {
  name = "/${var.environment}/services/fundraising"

  tags = {
    Environment = var.environment
    Application = "fundraising"
    Terraform   = true
  }
}

resource "random_string" "secret_key_base" {
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
      name  = "RAILS_ENV",
      value = "production"
    },
    {
      name  = "RAILS_LOG_TO_STDOUT",
      value = true
    },
    {
      name  = "RAILS_SERVE_STATIC_FILES",
      value = true
    },
    {
      name  = "DATABASE_URL",
      value = var.database_url
    },
    {
      name  = "SECRET_KEY_BASE",
      value = random_string.secret_key_base.result
    },
    {
      name  = "REDIS_URL",
      value = var.redis_url
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
    "awslogs-group"  = aws_cloudwatch_log_group.fundraising.name
  }
}
