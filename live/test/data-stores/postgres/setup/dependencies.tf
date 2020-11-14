data "terraform_remote_state" "postgres" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.postgres_remote_state_workspace
    }
  }
}

data "aws_ssm_parameter" "master_db_user" {
  name = data.terraform_remote_state.postgres.outputs.ssm_master_user_key
}

data "aws_ssm_parameter" "master_db_pass" {
  name = data.terraform_remote_state.postgres.outputs.ssm_master_pass_key
}

locals {
  environment                     = "test"
  postgres_remote_state_workspace = "test-postgres"
  remote_state_organization       = "debtcollective"
  master_db_user                  = data.aws_ssm_parameter.master_db_user.value
  master_db_pass                  = data.aws_ssm_parameter.master_db_pass.value
  master_db_name                  = data.terraform_remote_state.postgres.outputs.db_name
  master_db_port                  = data.terraform_remote_state.postgres.outputs.db_port
  table_privileges = [
    "DELETE",
    "INSERT",
    "REFERENCES",
    "SELECT",
    "TRIGGER",
    "TRUNCATE",
    "UPDATE"
  ]
  sequence_privileges = [
    "SELECT",
    "UPDATE",
    "USAGE"
  ]
}
