terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-postgres"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

module "postgres" {
  source      = "../../../../modules/data-stores/postgres"
  environment = "stage"

  db_password            = var.db_password
  db_username            = var.db_username
  subnet_ids             = local.subnet_ids
  vpc_id                 = local.vpc_id
  vpc_security_group_ids = local.vpc_security_group_ids
}
