resource "aws_cloudwatch_log_group" "fundraising" {
  name              = "/${var.environment}/services/fundraising"
  retention_in_days = var.log_retention_in_days

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
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.23.0"

  container_name               = local.container_name
  container_cpu                = null
  container_memory             = null
  container_memory_reservation = var.container_memory_reservation
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
      name  = "DISCOURSE_LOGIN_URL",
      value = var.discourse_login_url
    },
    {
      name  = "DISCOURSE_SIGNUP_URL",
      value = var.discourse_signup_url
    },
    {
      name  = "DISCOURSE_ADMIN_ROLE",
      value = var.discourse_admin_role
    },
    {
      name  = "SECRET_KEY_BASE",
      value = random_string.secret_key_base.result
    },
    {
      name  = "REDIS_URL",
      value = var.redis_url
    },
    {
      name  = "SSO_COOKIE_NAME",
      value = var.sso_cookie_name
    },
    {
      name  = "SSO_JWT_SECRET",
      value = var.sso_jwt_secret
    },
    {
      name  = "RECAPTCHA_SITE_KEY",
      value = var.recaptcha_site_key
    },
    {
      name  = "RECAPTCHA_SECRET_KEY",
      value = var.recaptcha_secret_key
    },
    {
      name  = "STRIPE_SECRET_KEY",
      value = var.stripe_secret_key
    },
    {
      name  = "STRIPE_PUBLISHABLE_KEY",
      value = var.stripe_publishable_key
    },
    {
      name  = "SENTRY_DSN",
      value = var.sentry_dsn
    },
    {
      name  = "PORT",
      value = local.container_port
    },
    {
      name  = "GA_MEASUREMENT_ID",
      value = var.ga_measurement_id
    },
    {
      name  = "AMPLITUDE_API_KEY",
      value = var.amplitude_api_key
    },
  ]

  port_mappings = [
    {
      containerPort = local.container_port
      hostPort      = null
      protocol      = "tcp"
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region" = data.aws_region.current.name
      "awslogs-group"  = aws_cloudwatch_log_group.fundraising.name
    }
    secretOptions = null
  }
}
