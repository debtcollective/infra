data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.vpc_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.cluster_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "postgres" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.postgres_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "postgres_setup" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.postgres_setup_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "redis" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.redis_remote_state_workspace
    }
  }
}

data "aws_ssm_parameter" "db_user" {
  name = data.terraform_remote_state.postgres_setup.outputs.directus_db_user_ssm_key
}

data "aws_ssm_parameter" "db_pass" {
  name = data.terraform_remote_state.postgres_setup.outputs.directus_db_pass_ssm_key
}

locals {
  environment = "prod"

  db_host     = data.terraform_remote_state.postgres.outputs.db_address
  db_name     = data.terraform_remote_state.postgres_setup.outputs.docassemble_db_name
  db_password = data.aws_ssm_parameter.db_pass.value
  db_port     = data.terraform_remote_state.postgres.outputs.db_port
  db_username = data.aws_ssm_parameter.db_user.value

  redis_remote_state_workspace = "${local.environment}-redis"
  redis_host                   = data.terraform_remote_state.redis.outputs.endpoint
  redis_port                   = data.terraform_remote_state.redis.outputs.port
  cache_redis                  = "redis://${local.redis_host}:${local.redis_port}/0"
  cache_store                  = "redis"
  cache_enabled                = "true"
  
  public_url = "https://admin.debtcollective.org"
  uploads_bucket_name = "directus-uploads-${local.environment}"

  ecs_cluster_id = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  lb_dns_name    = data.terraform_remote_state.cluster.outputs.lb_dns_name
  lb_listener_id = data.terraform_remote_state.cluster.outputs.lb_listener_id
  lb_zone_id     = data.terraform_remote_state.cluster.outputs.lb_zone_id
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id

  cluster_remote_state_workspace        = "${local.environment}-cluster"
  iam_remote_state_workspace            = "global-iam"
  postgres_remote_state_workspace       = "${local.environment}-postgres"
  postgres_setup_remote_state_workspace = "${local.environment}-postgres-setup"
  remote_state_organization             = "debtcollective"
  vpc_remote_state_workspace            = "${local.environment}-network"
}
