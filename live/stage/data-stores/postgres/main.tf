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

  db_username = var.db_username
  db_password = var.db_password
}
