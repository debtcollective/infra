data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.iam_remote_state_workspace
    }
  }
}

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

data "aws_ssm_parameter" "db_user" {
  name = data.terraform_remote_state.postgres_setup.outputs.disputes_api_db_user_ssm_key
}

data "aws_ssm_parameter" "db_pass" {
  name = data.terraform_remote_state.postgres_setup.outputs.disputes_api_db_pass_ssm_key
}

locals {
  environment = "stage"

  database_url            = "postgres://${local.db_user}:${urlencode(local.db_pass)}@${local.db_address}:${local.db_port}/${local.db_name}"
  db_address              = data.terraform_remote_state.postgres.outputs.db_address
  db_name                 = data.terraform_remote_state.postgres_setup.outputs.disputes_api_db_name
  db_pass                 = data.aws_ssm_parameter.db_pass.value
  db_port                 = data.terraform_remote_state.postgres.outputs.db_port
  db_user                 = data.aws_ssm_parameter.db_user.value
  lb_dns_name             = data.terraform_remote_state.cluster.outputs.lb_dns_name
  ec2_security_group_id   = data.terraform_remote_state.vpc.outputs.ec2_security_group_id
  ecs_cluster_id          = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  ecs_cluster_name        = data.terraform_remote_state.cluster.outputs.ecs_cluster_name
  elb_security_group_id   = data.terraform_remote_state.vpc.outputs.elb_security_group_id
  iam_instance_profile_id = data.terraform_remote_state.iam.outputs.instance_profile_id
  introspection           = true
  lb_listener_id          = data.terraform_remote_state.cluster.outputs.lb_listener_id
  ssh_key_pair_name       = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  subnet_ids              = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_security_group_ids  = [data.terraform_remote_state.vpc.outputs.rds_security_group_id]
  lb_zone_id              = data.terraform_remote_state.cluster.outputs.lb_zone_id

  acm_certificate_domain                = "*.debtcollective.org"
  cluster_remote_state_workspace        = "${local.environment}-cluster"
  iam_remote_state_workspace            = "global-iam"
  postgres_remote_state_workspace       = "${local.environment}-postgres"
  postgres_setup_remote_state_workspace = "${local.environment}-postgres-setup"
  remote_state_organization             = "debtcollective"
  vpc_remote_state_workspace            = "${local.environment}-network"
}
