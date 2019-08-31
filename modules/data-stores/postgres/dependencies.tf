data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = var.remote_state_organization

    workspaces = {
      name = var.vpc_remote_state_workspace
    }
  }
}

locals {
  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids             = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.rds_security_group_id]
}
