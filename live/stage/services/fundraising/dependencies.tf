data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = var.remote_state_organization

    workspaces = {
      name = var.vpc_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "postgres" {
  backend = "remote"

  config = {
    organization = var.remote_state_organization

    workspaces = {
      name = var.postgres_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = var.remote_state_organization

    workspaces = {
      name = var.iam_remote_state_workspace
    }
  }
}

locals {
  acm_certificate_domain  = "*.debtcollective.org"
  database_url            = data.terraform_remote_state.postgres.outputs.db_address
  ec2_security_group_id   = data.terraform_remote_state.vpc.outputs.ec2_security_group_id
  elb_security_group_id   = data.terraform_remote_state.vpc.outputs.elb_security_group_id
  iam_instance_profile_id = data.terraform_remote_state.iam.outputs.iam_instance_profile_id
  ssh_key_name            = data.terraform_remote_state.vpc.outputs.ssh_key_name
  subnet_ids              = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_security_group_ids  = [data.terraform_remote_state.vpc.outputs.rds_security_group_id]
}
