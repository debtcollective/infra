terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-network"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  version = "~> 2.0"
}

module "vpc" {
  source = "../../../modules/network/vpc"

  name        = "next"
  environment = "stage"
}
