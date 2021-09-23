resource "aws_cloudwatch_log_group" "docassemble" {
  name              = "/${var.environment}/services/docassemble"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "docassemble"
    Terraform   = true
  }
}

locals {
  s3_env_vars = [
    {
      name  = "S3ENABLE",
      value = true
    },
    {
      name  = "S3BUCKET",
      value = var.s3_bucket
    },
    {
      name  = "S3ACCESSKEY",
      value = var.s3_access_key_id
    },
    {
      name  = "S3SECRETACCESSKEY",
      value = var.s3_secret_access_key
    },
    {
      name  = "S3REGION",
      value = var.s3_region
    },
  ]
}

module "container_definition_backend" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.23.0"

  container_name               = local.backend_container_name
  container_cpu                = 1
  container_memory             = 1800
  container_memory_reservation = 1800
  essential                    = true
  container_image              = var.container_image

  environment = concat(local.s3_env_vars, [
    {
      name  = "BEHINDHTTPSLOADBALANCER",
      value = true
    },
    {
      name  = "CONTAINERROLE",
      value = "redis:rabbitmq:log:cron:mail"
    },
    {
      name  = "DAHOSTNAME",
      value = var.domain
    },
    {
      "name" = "EC2",
      "value" = "true"
    },
    {
      name  = "DBBACKUP",
      value = var.db_backups
    },
    {
      name  = "DBHOST",
      value = var.db_host
    },
    {
      name  = "DBNAME",
      value = var.db_name
    },
    {
      name  = "DBPASSWORD",
      value = var.db_password
    },
    {
      name  = "DBUSER",
      value = var.db_user
    },
    {
      name  = "REDIS",
      value = var.redis_url
    },
    {
      name  = "TIMEZONE",
      value = var.timezone
    },
  ])

  port_mappings = [
    {
      containerPort = "25"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "514"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "4369"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "8080"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "8082"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "5671"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "5672"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "25672"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "9001"
      hostPort      = null
      protocol      = "tcp"
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region" = data.aws_region.current.name
      "awslogs-group"  = aws_cloudwatch_log_group.docassemble.name
    }
    secretOptions = null
  }
}

module "container_definition_app" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.23.0"

  container_name               = local.app_container_name
  container_cpu                = 1
  container_memory             = 1800
  container_memory_reservation = 1800
  essential                    = true
  container_image              = var.container_image

  environment = concat(local.s3_env_vars, [
    {
      name  = "CONTAINERROLE",
      value = "web:celery"
    },
  ])

  port_mappings = [
    {
      containerPort = local.container_port
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "8081"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "9001"
      hostPort      = null
      protocol      = "tcp"
    },
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region" = data.aws_region.current.name
      "awslogs-group"  = aws_cloudwatch_log_group.docassemble.name
    }
    secretOptions = null
  }
}
