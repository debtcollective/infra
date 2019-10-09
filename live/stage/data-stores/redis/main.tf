terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-redis"
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
  source = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=tags/0.13.0"
  stage  = "stage"
  name   = "redis"

  # This is the security groups that will have access to Redis
  security_groups             = local.vpc_security_group_ids
  vpc_id                      = local.vpc_id
  subnets                     = local.subnet_ids
  instance_type               = "cache.t2.micro"
  engine_version              = "4.0.10"
  alarm_cpu_threshold_percent = 90
  transit_encryption_enabled  = false
  auth_token                  = null
  availability_zones          = data.aws_availability_zones.available.names
  automatic_failover          = false
}
