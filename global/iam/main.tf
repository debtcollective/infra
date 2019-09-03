terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "global-iam"
    }
  }
}

module "ecs_role" {
  source = "../../modules/iam/ecs_role"

  prefix = "next"
}
