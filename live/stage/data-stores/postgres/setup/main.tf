terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-postgres-setup"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

provider "postgresql" {
  connect_timeout = 15
  database        = local.master_db_name
  host            = "localhost"
  password        = local.master_db_pass
  port            = local.master_db_port
  sslmode         = "require"
  superuser       = false
  username        = local.master_db_user
}
