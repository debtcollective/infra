resource "aws_cloudwatch_log_group" "directus" {
  name              = "/${var.environment}/services/directus"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "directus"
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
      name  = "DB_CLIENT",
      value = "pg"
    },
    {
      name  = "DB_DATABASE",
      value = var.db_name
    },
    {
      name  = "DB_PORT",
      value = var.db_port
    },
    {
      name  = "DB_USER",
      value = var.db_username
    },
    {
      name  = "DB_PASSWORD",
      value = var.db_password
    },
    {
      name  = "DB_HOST",
      value = var.db_host
    },
    {
      name  = "KEY",
      value = var.directus_key
    },
    {
      name  = "SECRET",
      value = var.directus_secret
    },
    {
      name  = "CACHE_ENABLED",
      value = var.cache_enabled
    },
    {
      name  = "CACHE_STORE",
      value = var.cache_store
    },
    {
      name  = "CACHE_REDIS",
      value = var.cache_redis
    },
    /* Storage, we use AWS S3 */
    {
      name  = "ACTIVE_STORAGE_SERVICE",
      value = "amazon"
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
    {
      name  = "ADMIN_EMAIL",
      value = var.admin_email
    },
    {
      name  = "ADMIN_PASSWORD",
      value = var.admin_password
    },
    {
      name  = "PUBLIC_URL",
      value = var.public_url
    },
    {
      name  = "STORAGE_LOCATIONS",
      value = var.storage_locations
    },
    {
      name  = "STORAGE_S3_DRIVER",
      value = var.storage_s3_driver
    },
    {
      name  = "STORAGE_S3_ROOT",
      value = var.storage_s3_root
    },
    {
      name  = "STORAGE_S3_KEY",
      value = var.storage_s3_key
    },
    {
      name  = "STORAGE_S3_SECRET",
      value = var.storage_s3_secret
    },
    {
      name  = "STORAGE_S3_BUCKET",
      value = var.storage_s3_bucket
    },
    {
      name  = "STORAGE_S3_REGION",
      value = var.storage_s3_region
    },
    {
      name  = "STORAGE_S3_ACL",
      value = var.storage_s3_acl
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
      "awslogs-group"  = aws_cloudwatch_log_group.directus.name
    }
    secretOptions = null
  }
}
