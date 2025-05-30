terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-redis"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "redis" {
  source = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=tags/0.16.0"
  stage  = "prod"
  name   = "redis"

  alarm_cpu_threshold_percent  = 85
  auth_token                   = null
  availability_zones           = data.aws_availability_zones.available.names
  engine_version               = "6.0"
  family                       = "redis6.0"
  existing_security_groups     = local.vpc_security_group_ids
  instance_type                = "cache.t3.micro"
  subnets                      = local.subnet_ids
  transit_encryption_enabled   = false
  use_existing_security_groups = true
  vpc_id                       = local.vpc_id

  parameter = []
}
