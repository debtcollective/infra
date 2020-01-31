terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-app-discourse"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "discourse" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "discourse-${local.environment}"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

locals {
  domain = aws_route53_record.discourse.fqdn
}

module "discourse" {
  source      = "../../../../modules/services/discourse"
  environment = local.environment

  domain             = local.domain
  discourse_hostname = local.domain

  discourse_smtp_address  = var.discourse_smtp_address
  discourse_smtp_username = var.discourse_smtp_username
  discourse_smtp_password = var.discourse_smtp_password

  discourse_db_host     = local.db_address
  discourse_db_name     = local.db_name
  discourse_db_username = local.db_user
  discourse_db_password = local.db_user
  discourse_sso_secret  = var.discourse_sso_secret

  discourse_reply_by_email_address = var.discourse_reply_by_email_address
  discourse_pop3_polling_username  = var.discourse_pop3_polling_username
  discourse_pop3_polling_password  = var.discourse_pop3_polling_password
  discourse_pop3_polling_host      = var.discourse_pop3_polling_host
  discourse_pop3_polling_port      = var.discourse_pop3_polling_port

  discourse_ga_universal_tracking_code = var.discourse_ga_universal_tracking_code
  discourse_maxmind_license_key        = var.discourse_maxmind_license_key

  acm_certificate_domain = "*.${local.domain}"

  key_name        = local.ssh_key_pair_name
  subnet_id       = local.subnet_id
  security_groups = local.ec2_security_group_id
}
