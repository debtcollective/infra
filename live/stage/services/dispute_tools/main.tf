terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-app-dispute-tools"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "dispute_tools" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "dispute-tools-infra"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "dispute_tools" {
  source      = "../../../../modules/services/dispute_tools"
  environment = local.environment

  domain         = aws_route53_record.dispute_tools.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  db_connection_string = "postgres://${local.db_username}:${local.db_password}@${local.db_host}:${local.db_port}/${local.db_name}"
  sso_secret           = local.sso_jwt_secret

  smtp_host            = var.smtp_host
  smtp_pass            = var.smtp_pass
  smtp_port            = var.smtp_port
  smtp_user            = var.smtp_user
  contact_email        = var.contact_email
  disputes_bcc_address = var.disputes_bcc_address
  sender_email         = var.sender_email

  sso_cookie_name          = "_dispute_tools__${local.environment}"
  landing_page_url         = "https://debtcollective.org"
  site_url                 = "https://${aws_route53_record.dispute_tools.fqdn}"
  sso_endpoint             = "https://community.debtcollective.org/session/sso_provider"
  discourse_base_url       = "https://community.debtcollective.org"
  static_assets_bucket_url = "https://s3.amazonaws.com/tds-static"
  discourse_api_key        = var.discourse_api_key
  discourse_api_username   = var.discourse_api_username

  aws_upload_bucket        = var.aws_upload_bucket
  aws_upload_bucket_region = var.aws_upload_bucket_region
  aws_access_key_id        = var.aws_access_key_id
  aws_secret_access_key    = var.aws_secret_access_key

  doe_disclosure_representatives = var.doe_disclosure_representatives
  doe_disclosure_phones          = var.doe_disclosure_phones
  doe_disclosure_relationship    = var.doe_disclosure_relationship
  doe_disclosure_address         = var.doe_disclosure_address
  doe_disclosure_city            = var.doe_disclosure_city
  doe_disclosure_state           = var.doe_disclosure_state
  doe_disclosure_zip             = var.doe_disclosure_zip

  stripe_private       = var.stripe_private
  stripe_publishable   = var.stripe_publishable
  loggly_api_key       = var.loggly_api_key
  sentry_endpoint      = var.sentry_endpoint
  google_maps_api_key  = var.google_maps_api_key
  jwt_secret           = var.jwt_secret
  recaptcha_site_key   = var.recaptcha_site_key
  recaptcha_secret_key = var.recaptcha_secret_key
  google_analytics_ua  = var.google_analytics_ua
}
