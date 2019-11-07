terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-cluster"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "stage"
}

module "cluster" {
  source      = "../../../../modules/services/cluster"
  environment = local.environment

  security_group_ids = local.security_group_ids
  subnet_ids         = local.subnet_ids
}
