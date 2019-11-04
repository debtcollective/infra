terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-service-mail-for-good"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "stage"
  domain      = "mfg"
  fqdn        = "mfg.debtcollective.org"
}

module "mail_for_good" {
  source      = "../../../../modules/services/mail_for_good"
  environment = local.environment

  acm_certificate_domain  = local.acm_certificate_domain
  elb_security_groups     = [local.elb_security_group_id]
  vpc_id                  = local.vpc_id
  key_name                = local.ssh_key_pair_name
  iam_instance_profile_id = local.iam_instance_profile_id
  subnet_ids              = local.subnet_ids
  security_groups         = [local.ec2_security_group_id]

  database_user            = local.database_user
  database_password        = local.database_password
  database_host            = local.database_host
  database_name            = local.database_name
  domain                   = local.domain
  google_consumer_key      = local.google_consumer_key
  google_secret_key        = local.google_secret_key
  amazon_access_key_id     = local.amazon_access_key_id
  amazon_secret_access_key = local.amazon_secret_access_key
  redis_url                = local.redis_url
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "mail_for_good" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.domain
  type    = "A"

  alias {
    name                   = module.mail_for_good.dns_name
    zone_id                = module.mail_for_good.zone_id
    evaluate_target_health = true
  }
}
