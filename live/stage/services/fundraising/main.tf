terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-app-fundraising"
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

  acm_certificate_domain  = local.acm_certificate_domain
  elb_security_groups     = [local.elb_security_group_id]
  vpc_id                  = local.vpc_id
  key_name                = local.ssh_key_pair_name
  iam_instance_profile_id = local.iam_instance_profile_id
  subnet_ids              = local.subnet_ids
  security_groups         = [local.ec2_security_group_id]

  database_url         = local.database_url
  discourse_login_url  = local.discourse_login_url
  discourse_signup_url = local.discourse_signup_url
  redis_url            = local.redis_url
  sso_cookie_name      = local.sso_cookie_name
  sso_jwt_secret       = local.sso_jwt_secret
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "fundraising" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "fundraising-${local.environment}"
  type    = "A"

  alias {
    name                   = module.fundraising.dns_name
    zone_id                = module.fundraising.zone_id
    evaluate_target_health = true
  }
}
