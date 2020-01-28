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
  name = data.terraform_remote_state.postgres_setup.outputs.fundraising_db_user_ssm_key
}

data "aws_ssm_parameter" "db_pass" {
  name = data.terraform_remote_state.postgres_setup.outputs.fundraising_db_pass_ssm_key
}

// hard coded until we migrate Discourse to this repo
data "aws_ssm_parameter" "discourse_sso_jwt_secret" {
  name = "/production/services/discourse/sso_jwt_secret"
}

locals {
  environment = "stage"

  database_url         = "postgres://${local.db_user}:${urlencode(local.db_pass)}@${local.db_address}:${local.db_port}/${local.db_name}"
  db_address           = data.terraform_remote_state.postgres.outputs.db_address
  db_name              = data.terraform_remote_state.postgres_setup.outputs.fundraising_db_name
  db_pass              = data.aws_ssm_parameter.db_pass.value
  db_port              = data.terraform_remote_state.postgres.outputs.db_port
  db_user              = data.aws_ssm_parameter.db_user.value
  discourse_login_url  = "${local.discourse_uri}/session/sso_cookies"
  discourse_signup_url = "${local.discourse_uri}/session/sso_cookies/signup"
  discourse_uri        = "https://community.debtcollective.org"
  redis_host           = data.terraform_remote_state.redis.outputs.host
  redis_port           = data.terraform_remote_state.redis.outputs.port
  redis_url            = "redis://${local.redis_host}:${local.redis_port}/0"
  sso_cookie_name      = "tdc_auth_production"
  sso_jwt_secret       = data.aws_ssm_parameter.discourse_sso_jwt_secret.value

  ecs_cluster_id = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  lb_dns_name    = data.terraform_remote_state.cluster.outputs.lb_dns_name
  lb_listener_id = data.terraform_remote_state.cluster.outputs.lb_listener_id
  lb_zone_id     = data.terraform_remote_state.cluster.outputs.lb_zone_id
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id

  cluster_remote_state_workspace        = "${local.environment}-cluster"
  iam_remote_state_workspace            = "global-iam"
  postgres_remote_state_workspace       = "${local.environment}-postgres"
  postgres_setup_remote_state_workspace = "${local.environment}-postgres-setup"
  redis_remote_state_workspace          = "${local.environment}-redis"
  remote_state_organization             = "debtcollective"
  vpc_remote_state_workspace            = "${local.environment}-network"
}
