terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-bastion"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "prod"
}

module "bastion" {
  source      = "../../../../modules/services/bastion"
  environment = local.environment

  key_name               = local.ssh_key_pair_name
  subnet_id              = local.subnet_id
  vpc_security_group_ids = [local.ec2_security_group_id]
}
