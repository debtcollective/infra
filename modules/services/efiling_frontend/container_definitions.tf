resource "aws_cloudwatch_log_group" "efiling_frontend" {
  name              = "/${var.environment}/services/efiling_frontend"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.environment
    Application = "efiling_frontend"
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
      name  = "BACKEND_URL",
      value = var.backend_url
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
      "awslogs-group"  = aws_cloudwatch_log_group.efiling_frontend.name
    }
    secretOptions = null
  }
}
