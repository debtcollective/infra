resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/${var.environment}/services/strapi"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "strapi"
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
      name  = "DATABASE_CLIENT",
      value = "postgres"
    },
    {
      name  = "DATABASE_NAME",
      value = var.db_name
    },
    {
      name  = "DATABASE_PORT",
      value = var.db_port
    },
    {
      name  = "DATABASE_USERNAME",
      value = var.db_username
    },
    {
      name  = "DATABASE_PASSWORD",
      value = var.db_password
    },
    {
      name  = "DATABASE_HOST",
      value = var.db_host
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
      "awslogs-group"  = aws_cloudwatch_log_group.strapi.name
    }
    secretOptions = null
  }
}
