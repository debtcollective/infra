terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-network"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "stage"
}

module "vpc" {
  source = "../../../modules/network/vpc"

  name        = "next"
  environment = local.environment
}

// create aws key pair to be used
resource "aws_key_pair" "ssh" {
  key_name   = "${local.environment}-kp"
  public_key = var.ssh_public_key
}
