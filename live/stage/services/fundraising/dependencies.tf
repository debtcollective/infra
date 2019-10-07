data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.vpc_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.iam_remote_state_workspace
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

locals {
  db_user      = data.aws_ssm_parameter.db_user.value
  db_pass      = data.aws_ssm_parameter.db_pass.value
  db_address   = data.terraform_remote_state.postgres.outputs.db_address
  db_port      = data.terraform_remote_state.postgres.outputs.db_port
  db_name      = data.terraform_remote_state.postgres_setup.outputs.fundraising_db_name
  redis_host   = data.terraform_remote_state.redis.outputs.host
  redis_port   = data.terraform_remote_state.redis.outputs.port
  database_url = "postgres://${local.db_user}:${urlencode(local.db_pass)}@${local.db_address}:${local.db_port}/${local.db_name}"
  redis_url    = "redis://${local.redis_host}:${local.redis_port}"

  acm_certificate_domain                = "*.debtcollective.org"
  ec2_security_group_id                 = data.terraform_remote_state.vpc.outputs.ec2_security_group_id
  elb_security_group_id                 = data.terraform_remote_state.vpc.outputs.elb_security_group_id
  iam_instance_profile_id               = data.terraform_remote_state.iam.outputs.instance_profile_id
  iam_remote_state_workspace            = "global-iam"
  postgres_remote_state_workspace       = "stage-postgres"
  postgres_setup_remote_state_workspace = "stage-postgres-setup"
  redis_remote_state_workspace          = "stage-redis"
  remote_state_organization             = "debtcollective"
  ssh_key_pair_name                     = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  subnet_ids                            = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  vpc_id                                = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_remote_state_workspace            = "stage-network"
  vpc_security_group_ids                = [data.terraform_remote_state.vpc.outputs.rds_security_group_id]
}
