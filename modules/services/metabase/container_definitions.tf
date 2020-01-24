resource "aws_cloudwatch_log_group" "metabase" {
  name = "/${var.environment}/services/metabase"

  tags = {
    Environment = var.environment
    Application = "metabase"
    Terraform   = true
  }
}

module "container_definitions" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.23.0"

  container_name               = local.container_name
  container_cpu                = 0
  container_memory             = 0
  container_memory_reservation = var.container_memory_reservation
  essential                    = true
  container_image              = var.container_image

  environment = [
    {
      name  = "MB_DB_TYPE",
      value = "postgres"
    },
    {
      name  = "MB_DB_DBNAME",
      value = var.db_name
    },
    {
      name  = "MB_DB_PORT",
      value = var.db_port
    },
    {
      name  = "MB_DB_USER",
      value = var.db_username
    },
    {
      name  = "MB_DB_PASS",
      value = var.db_password
    },
    {
      name  = "MB_DB_HOST",
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
      "awslogs-group"  = aws_cloudwatch_log_group.metabase.name
      "max-size"       = "10m"
      "max-file"       = "3"
    }
    secretOptions = null
  }
}
