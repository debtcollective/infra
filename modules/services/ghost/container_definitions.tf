resource "aws_cloudwatch_log_group" "ghost" {
  name              = "/${var.environment}/services/ghost"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "ghost"
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
      name  = "database__connection__user",
      value = var.db_username
    },
    {
      name  = "database__connection__password",
      value = var.db_password
    },
    {
      name  = "database__connection__host",
      value = var.db_host
    },
    {
      name  = "url",
      value = "https://${var.domain}"
    },
    {
      name  = "NODE_ENV",
      value = "production"
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
      "awslogs-group"  = aws_cloudwatch_log_group.ghost.name
    }
    secretOptions = null
  }
}
