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

locals {
  environment = "stage"
}

module "fundraising" {
  source      = "../../../../modules/services/fundraising"
  environment = local.environment

  database_url = local.database_url

  acm_certificate_domain = local.acm_certificate_domain
  elb_security_groups    = [local.elb_security_group_id]
  vpc_id                 = local.vpc_id

  key_name                = local.ssh_key_name
  iam_instance_profile_id = local.iam_instance_profile_id
  subnet_ids              = local.subnet_ids
  security_groups         = [local.ec2_security_group_id]
}
