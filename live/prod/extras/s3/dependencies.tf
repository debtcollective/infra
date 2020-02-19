data "terraform_remote_state" "discourse" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.discourse_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "dispute_tools" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.dispute_tools_remote_state_workspace
    }
  }
}

locals {
  remote_state_organization            = "debtcollective"
  discourse_remote_state_workspace     = "prod-app-discourse"
  dispute_tools_remote_state_workspace = "prod-app-dispute-tools"
  discourse_uploads_bucket_arn         = data.terraform_remote_state.discourse.outputs.uploads_bucket_arn
  discourse_uploads_bucket_name        = data.terraform_remote_state.discourse.outputs.uploads_bucket_name
  dispute_tools_uploads_bucket_arn     = data.terraform_remote_state.dispute_tools.outputs.uploads_bucket_arn
  dispute_tools_uploads_bucket_name    = data.terraform_remote_state.dispute_tools.outputs.uploads_bucket_name
}
