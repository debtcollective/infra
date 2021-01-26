resource "aws_cloudwatch_log_group" "chatwoot" {
  name              = "/${var.environment}/services/chatwoot"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "chatwoot"
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
    /* Email */
    {
      name  = "MAILER_SENDER_EMAIL",
      value = var.mailer_sender_email
    },
    {
      name  = "SMTP_ADDRESS",
      value = var.smtp_address
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
      name  = "SMTP_AUTHENTICATION",
      value = "plain"
    },
    {
      name  = "SMTP_DOMAIN",
      value = var.smtp_domain
    },
    {
      name  = "SMTP_ENABLE_STARTTLS_AUTO",
      value = true
    },
    {
      name  = "SMTP_PORT",
      value = var.smtp_port
    },

    /* App */
    {
      name  = "FRONTEND_URL",
      value = var.frontend_url
    },
    {
      name  = "DEFAULT_LOCALE",
      value = var.default_locale
    },
    {
      name  = "DATABASE_URL",
      value = var.database_url
    },
    {
      name  = "RAILS_ENV",
      value = var.rails_env
    },
    {
      name  = "SECRET_KEY_BASE",
      value = var.secret_key_base
    },
    {
      name  = "LOG_LEVEL",
      value = var.log_level
    },

    /* Push notifications */
    {
      name  = "VAPID_PUBLIC_KEY",
      value = var.vapid_public_key
    },
    {
      name  = "VAPID_PRIVATE_KEY",
      value = var.vapid_private_key
    },

    /* Storage, we use AWS S3 */
    {
      name  = "ACTIVE_STORAGE_SERVICE",
      value = "amazon"
    },
    {
      name  = "S3_BUCKET_NAME",
      value = var.s3_bucket_name
    },
    {
      name  = "AWS_ACCESS_KEY_ID",
      value = var.aws_access_key_id
    },
    {
      name  = "AWS_SECRET_ACCESS_KEY",
      value = var.aws_secret_access_key
    },
    {
      name  = "AWS_REGION",
      value = var.aws_region
    },

    /* Redis */
    {
      name  = "REDIS_URL",
      value = var.redis_url
    },

    /* Channels */
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
      "awslogs-group"  = aws_cloudwatch_log_group.chatwoot.name
    }
    secretOptions = null
  }
}
