terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-bastion"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "test"
}
