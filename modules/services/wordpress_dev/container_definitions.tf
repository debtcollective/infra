resource "aws_cloudwatch_log_group" "wordpress_dev" {
  name              = "/${var.environment}/services/wordpress_dev"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "wordpress_dev"
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
      value = "dev"
    },
    {
      name  = "COMMUNITY_URL",
      value = var.community_url
    },
    {
      name  = "WORDPRESS_URL",
      value = var.wordpress_url
    },{
      name  = "RETURN_URL",
      value = var.return_url
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
      containerPath = "/var/www/html_dev",
      sourceVolume = "efs-wordpress-data-dev"
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
      "awslogs-group"  = aws_cloudwatch_log_group.wordpress_dev.name
    }
    secretOptions = null
  }
}
