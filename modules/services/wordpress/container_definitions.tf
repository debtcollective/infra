resource "aws_cloudwatch_log_group" "wordpress" {
  name              = "/${var.environment}/services/wordpress"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "wordpress"
    Terraform   = true
  }
}

module "container_definitions" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.25.0"

  container_name               = local.container_name
  container_cpu                = null
  container_memory             = null
  container_memory_reservation = var.container_memory_reservation
  essential                    = true
  container_image              = var.container_image

  environment = [
    {
      name  = "database__client",
      value = "mysql"
    },
    {
      name  = "database__connection__database",
      value = var.db_name
    },
    {
      name  = "database__connection__host",
      value = var.db_host
    },
    {
      name  = "mail__transport",
      value = var.mail_transport
    },
    {
      name  = "mail__from",
      value = var.mail_from
    },
    {
      name  = "mail__options__service",
      value = var.mail_transport
    },
    {
      name  = "mail__options__host",
      value = var.mail_host
    },
    {
      name  = "mail__options__port",
      value = var.mail_port
    },
    {
      name  = "mail__options__auth__user",
      value = var.mail_user
    },
    {
      name  = "mail__options__auth__pass",
      value = var.mail_pass
    },
    {
      name  = "storage__active",
      value = "wordpress-s3"
    },
    {
      name  = "storage__wordpress-s3__accessKeyId",
      value = var.s3_access_key_id
    },
    {
      name  = "storage__wordpress-s3__secretAccessKey",
      value = var.s3_secret_access_key
    },
    {
      name  = "storage__wordpress-s3__bucket",
      value = var.s3_bucket
    },
    {
      name  = "storage__wordpress-s3__region",
      value = var.s3_region
    },
    {
      name  = "storage__wordpress-s3__assetHost",
      value = var.cdn_url
    },
    {
      name  = "url",
      value = "https://${var.domain}"
    },
    {
      name  = "ENVIRONMENT",
      value = "production"
    },
    {
      name  = "dc_donate_api_url",
      value = var.dc_donate_api_url
    },
    {
      name  = "dc_membership_api_url",
      value = var.dc_membership_api_url
    },{
      name  = "dc_funds_api_url",
      value = var.dc_funds_api_url
    },
    {
      name  = "dc_recaptcha_v3_site_key",
      value = var.dc_recaptcha_v3_site_key
    },{
      name  = "dc_stripe_public_token",
      value = "https://${var.domain}"
    }
  ]

  secrets = [
    {
      name : "database__connection__user",
      valueFrom : var.db_username_ssm_key
    },
    {
      name : "database__connection__password",
      valueFrom : var.db_password_ssm_key
    }
  ]

  mount_points = [
    {
      containerPath = "/var/www/html",
      sourceVolume = "efs-wordpress-data"
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
      "awslogs-group"  = aws_cloudwatch_log_group.wordpress.name
    }
    secretOptions = null
  }
}
