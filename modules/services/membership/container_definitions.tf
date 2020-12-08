resource "aws_cloudwatch_log_group" "membership" {
  name              = "/${var.environment}/services/membership"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "membership"
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
      name  = "ASSET_HOST",
      value = var.domain
    },
    {
      name  = "MAIL_FROM",
      value = var.mail_from
    },
    {
      name  = "SMTP_ADDRESS",
      value = var.smtp_address
    },
    {
      name  = "SMTP_PORT",
      value = var.smtp_port
    },
    {
      name  = "SMTP_DOMAIN",
      value = var.smtp_domain
    },
    {
      name  = "SMTP_USERNAME",
      value = var.smtp_username
    },
    {
      name  = "SMTP_PASSWORD",
      value = var.smtp_password
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
      name  = "DISCOURSE_URL",
      value = var.discourse_url
    },
    {
      name  = "DISCOURSE_USERNAME",
      value = var.discourse_username
    },
    {
      name  = "DISCOURSE_API_KEY",
      value = var.discourse_api_key
    },
    {
      name  = "HOME_PAGE_URL",
      value = var.home_page_url
    },
    {
      name  = "CORS_ORIGINS",
      value = var.cors_origins
    },
    {
      name  = "COOKIE_DOMAIN",
      value = var.cookie_domain
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
      name  = "RECAPTCHA_V3_SECRET_KEY",
      value = var.recaptcha_v3_secret_key
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
      name  = "SENTRY_ENVIRONMENT",
      value = var.sentry_environment
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
    {
      name  = "SKYLIGHT_AUTHENTICATION",
      value = var.skylight_authentication
    },
    {
      name  = "MAILCHIMP_API_KEY",
      value = var.mailchimp_api_key
    },
    {
      name  = "MAILCHIMP_LIST_ID",
      value = var.mailchimp_list_id
    }
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
      "awslogs-group"  = aws_cloudwatch_log_group.membership.name
    }
    secretOptions = null
  }
}
