resource "aws_cloudwatch_log_group" "docassemble" {
  name              = "/${var.environment}/services/docassemble"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "docassemble"
    Terraform   = true
  }
}

module "container_definitions_backend" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.23.0"

  container_name               = "${local.container_name}-backend"
  container_cpu                = null
  container_memory             = null
  container_memory_reservation = var.container_memory_reservation
  essential                    = true
  container_image              = var.container_image

  environment = [
    {
      name  = "BEHINDHTTPSLOADBALANCER",
      value = true
    },
    {
      name  = "EC2",
      value = true
    },
    {
      name  = "DAHOSTNAME",
      value = var.domain
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
      name  = "S3BUCKET",
      value = var.s3_bucket
    },
    {
      name  = "TIMEZONE",
      value = var.timezone
    }
  ]

  port_mappings = [
    {
      containerPort = local.container_port
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "514"
      hostPort      = null
      protocol      = "tcp"
    },
    {
      containerPort = "8082"
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

module "container_definitions_app" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.23.0"

  container_name               = "${local.container_name}-app"
  container_cpu                = null
  container_memory             = null
  container_memory_reservation = var.container_memory_reservation
  essential                    = true
  container_image              = var.container_image

  environment = [
    {
      name  = "CONTAINERROLE",
      value = "web:celery"
    },
    {
      name  = "S3BUCKET",
      value = "${s3_bucket}"
    },
  ]

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
