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

  security_group_ids = [data.terraform_remote_state.vpc.outputs.elb_security_group_id]
  subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}
