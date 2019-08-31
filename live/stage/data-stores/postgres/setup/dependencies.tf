data "terraform_remote_state" "postgres" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.postgres_remote_state_workspace
    }
  }
}

locals {
  environment                     = "stage"
  postgres_remote_state_workspace = "stage-postgres"
  remote_state_organization       = "debtcollective"
  master_db_name                  = data.terraform_remote_state.postgres.outputs.db_name
  master_db_port                  = data.terraform_remote_state.postgres.outputs.db_port
}
