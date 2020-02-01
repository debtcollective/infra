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
  name = data.terraform_remote_state.postgres_setup.outputs.discourse_db_user_ssm_key
}

data "aws_ssm_parameter" "db_pass" {
  name = data.terraform_remote_state.postgres_setup.outputs.discourse_db_pass_ssm_key
}

locals {
  environment = "stage"

  subdomain           = "discourse-${local.environment}"
  domain              = "debtcollective.org"
  fqdn                = "${local.subdomain}.debtcollective.org"
  s3_origin_id        = "${local.subdomain}"
  uploads_bucket_name = "discourse-uploads-${local.environment}"
  backups_bucket_name = "discourse-backups-${local.environment}"
  cdn_url             = ""

  db_address = data.terraform_remote_state.postgres.outputs.db_address
  db_name    = data.terraform_remote_state.postgres_setup.outputs.discourse_db_name
  db_pass    = data.aws_ssm_parameter.db_pass.value
  db_port    = data.terraform_remote_state.postgres.outputs.db_port
  db_user    = data.aws_ssm_parameter.db_user.value

  ssh_key_pair_name     = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id             = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  ec2_security_group_id = data.terraform_remote_state.vpc.outputs.ec2_security_group_id

  cluster_remote_state_workspace        = "${local.environment}-cluster"
  iam_remote_state_workspace            = "global-iam"
  postgres_remote_state_workspace       = "${local.environment}-postgres"
  postgres_setup_remote_state_workspace = "${local.environment}-postgres-setup"
  remote_state_organization             = "debtcollective"
  vpc_remote_state_workspace            = "${local.environment}-network"
}
