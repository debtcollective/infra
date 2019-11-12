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

locals {
  environment = "stage"

  ec2_security_group_ids  = [data.terraform_remote_state.vpc.outputs.ec2_security_group_id]
  elb_security_group_ids  = [data.terraform_remote_state.vpc.outputs.elb_security_group_id]
  iam_instance_profile_id = data.terraform_remote_state.iam.outputs.instance_profile_id
  instance_type           = "t3a.nano"
  key_name                = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  subnet_ids              = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id

  iam_remote_state_workspace = "global-iam"
  remote_state_organization  = "debtcollective"
  vpc_remote_state_workspace = "${local.environment}-network"

}
