terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-mysql-setup"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

provider "mysql" {
  host     = "localhost:3306"
  username = local.master_db_user
  password = local.master_db_pass
  tls      = true
}
