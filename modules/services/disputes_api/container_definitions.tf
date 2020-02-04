resource "aws_cloudwatch_log_group" "disputes_api" {
  name              = "/${var.environment}/services/disputes_api"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "disputes_api"
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
      name  = "NODE_ENV",
      value = "production"
    },
    {
      name  = "DB_CONNECTION_STRING",
      value = var.database_url
    },
    {
      name  = "INTROSPECTION",
      value = var.introspection
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
      "awslogs-group"  = aws_cloudwatch_log_group.disputes_api.name
    }
    secretOptions = null
  }
}
