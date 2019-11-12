resource "aws_cloudwatch_log_group" "disputes_api" {
  name = "/${var.environment}/services/disputes_api"

  tags = {
    Environment = var.environment
    Application = "disputes_api"
    Terraform   = true
  }
}

module "container_definitions" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.15.0"

  container_name               = local.container_name
  container_cpu                = 0
  container_memory             = 0
  container_memory_reservation = 230
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
    }
  ]

  log_driver = "awslogs"
  log_options = {
    "awslogs-region" = data.aws_region.current.name
    "awslogs-group"  = aws_cloudwatch_log_group.disputes_api.name
  }
}
