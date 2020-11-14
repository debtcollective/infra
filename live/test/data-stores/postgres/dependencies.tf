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
  subnet_ids                 = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  vpc_id                     = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_remote_state_workspace = "test-network"
  vpc_security_group_ids     = [data.terraform_remote_state.vpc.outputs.rds_security_group_id]
}
