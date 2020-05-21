resource "aws_cloudwatch_log_group" "campaign_api" {
  name              = "/${var.environment}/services/campaign_api"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "campaign_api"
    Terraform   = true
  }
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
      name  = "NODE_ENV",
      value = "production"
    },
    {
      name  = "DB_CONNECTION_STRING",
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
      name  = "SSO_COOKIE_NAME",
      value = var.sso_cookie_name
    },
    {
      name  = "SSO_JWT_SECRET",
      value = var.sso_jwt_secret
    },
    {
      name  = "CORS_ORIGIN",
      value = var.cors_origin
    },
    {
      name  = "SENTRY_DSN",
      value = var.sentry_dsn
    },
    {
      name  = "INTROSPECTION",
      value = var.introspection
    },
    {
      name  = "PLAYGROUND",
      value = var.playground
    },
    {
      name  = "DISCOURSE_BADGE_ID",
      value = var.discourse_badge_id
    },
    {
      name  = "DISCOURSE_API_USERNAME",
      value = var.discourse_api_username
    },
    {
      name  = "DISCOURSE_API_KEY",
      value = var.discourse_api_key
    },
    {
      name  = "DISCOURSE_API_URL",
      value = var.discourse_api_url
    },
    {
      name  = "MAILCHIMP_API_KEY",
      value = var.mailchimp_api_key
    },
    {
      name  = "MAILCHIMP_LIST_ID",
      value = var.mailchimp_list_id
    },
    {
      name  = "MAILCHIMP_TAG",
      value = var.mailchimp_tag
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
      "awslogs-group"  = aws_cloudwatch_log_group.campaign_api.name
    }
    secretOptions = null
  }
}
