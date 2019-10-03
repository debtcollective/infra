terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-app-disputes-api"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "stage"
}

module "disputes_api" {
  source      = "../../../../modules/services/disputes_api"
  environment = local.environment

  acm_certificate_domain  = local.acm_certificate_domain
  elb_security_groups     = [local.elb_security_group_id]
  vpc_id                  = local.vpc_id
  key_name                = local.ssh_key_pair_name
  iam_instance_profile_id = local.iam_instance_profile_id
  subnet_ids              = local.subnet_ids
  security_groups         = [local.ec2_security_group_id]

  database_url  = local.database_url
  introspection = local.introspection
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "disputes_api" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "disputes-api-${local.environment}"
  type    = "A"

  alias {
    name                   = module.disputes_api.dns_name
    zone_id                = module.disputes_api.zone_id
    evaluate_target_health = true
  }
}
