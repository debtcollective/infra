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
  remote_state_organization  = "debtcollective"
  vpc_remote_state_workspace = "stage-network"
  ec2_security_group_id      = data.terraform_remote_state.vpc.outputs.ec2_security_group_id
  ssh_key_pair_name          = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  subnet_id                  = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
}
