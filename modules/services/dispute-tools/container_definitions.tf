resource "aws_cloudwatch_log_group" "dispute_tools" {
  name = "/${var.environment}/services/dispute_tools"

  tags = {
    Environment = var.environment
    Application = "dispute_tools"
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
      name  = "REDIS_HOST",
      value = local.redis_host
    },
    {
      name  = "REDIS_PORT",
      value = local.redis_port
    },
    {
      name  = "SSO_ENDPOINT",
      value = local.sso_endpoint
    },
    {
      name  = "SSO_SECRET",
      value = var.sso_secret
    },
    {
      name  = "JWT_SECRET",
      value = var.jwt_secret
    },
    {
      name  = "SSO_COOKIE_NAME",
      value = var.sso_cookie_name
    },
    {
      name  = "NODE_ENV",
      value = "production"
    },
    {
      name  = "SITE_URL",
      value = var.domain
    },
    {
      name  = "LANDING_PAGE_URL",
      value = local.landing_page_url
    },
    {
      name  = "EMAIL_CONTACT",
      value = local.contact_email
    },
    {
      name  = "EMAIL_NO_REPLY",
      value = local.sender_email
    },
    {
      name  = "EMAIL_DISPUTES_BCC",
      value = local.disputes_bcc_address
    },
    {
      name  = "EMAIL_HOST",
      value = var.smtp_host
    },
    {
      name  = "EMAIL_PORT",
      value = var.smtp_port
    },
    {
      name  = "EMAIL_SECURE",
      value = var.smtp_secure
    },
    {
      name  = "EMAIL_AUTH",
      value = var.smtp_user
    },
    {
      name  = "EMAIL_PASS",
      value = var.smtp_pass
    },
    {
      name  = "LOGGLY_KEY",
      value = var.loggly_api_key
    },
    {
      name  = "STATIC_ASSETS_BUCKET_URL",
      value = local.static_assets_bucket_url
    },
    {
      name  = "SENTRY_ENDPOINT",
      value = var.sentry_endpoint
    },
    {
      name  = "STRIPE_PRIVATE",
      value = var.stripe_private
    },
    {
      name  = "STRIPE_PUBLISHABLE",
      value = var.stripe_publishable
    },
    {
      name  = "GMAPS_KEY",
      value = var.google_maps_api_key
    },
    {
      name  = "AWS_UPLOAD_BUCKET",
      value = local.aws_bucket_name
    },
    {
      name  = "AWS_ACCESS_KEY_ID",
      value = var.aws_access_id
    },
    {
      name  = "AWS_SECRET_ACCESS_KEY",
      value = var.aws_access_secret
    },
    {
      name  = "AWS_DEFAULT_REGION",
      value = var.aws_region
    },
    {
      name  = "DB_CONNECTION_STRING",
      value = local.db_connection_string
    },
    {
      name  = "DB_POOL_MIN",
      value = local.db_pool_min
    },
    {
      name  = "DB_POOL_MAX",
      value = local.db_pool_max
    },
    {
      name  = "DISCOURSE_API_BASE_URL",
      value = local.discourse_base_url
    },
    {
      name  = "DISCOURSE_API_KEY",
      value = var.discourse_api_key
    },
    {
      name  = "DISCOURSE_API_USERNAME",
      value = var.discourse_api_username
    },
    {
      name  = "DOE_DISCLOSURE_REPRESENTATIVES",
      value = local.doe_disclosure_representatives
    },
    {
      name  = "DOE_DISCLOSURE_PHONES",
      value = local.doe_disclosure_phones
    },
    {
      name  = "DOE_DISCLOSURE_RELATIONSHIP",
      value = local.doe_disclosure_relationship
    },
    {
      name  = "DOE_DISCLOSURE_ADDRESS",
      value = local.doe_disclosure_address
    },
    {
      name  = "DOE_DISCLOSURE_CITY",
      value = local.doe_disclosure_city
    },
    {
      name  = "DOE_DISCLOSURE_STATE",
      value = local.doe_disclosure_state
    },
    {
      name  = "DOE_DISCLOSURE_ZIP",
      value = local.doe_disclosure_zip
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
      name  = "GOOGLE_ANALYTICS_UA",
      value = var.google_analytics_ua
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
      "awslogs-group"  = aws_cloudwatch_log_group.dispute_tools.name
    }
    secretOptions = null
  }
}
