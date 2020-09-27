terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-app-membership"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "membership" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "membership"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "membership" {
  source      = "../../../../modules/services/membership"
  environment = local.environment

  domain         = aws_route53_record.membership.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  amplitude_api_key       = var.amplitude_api_key
  database_url            = local.database_url
  discourse_login_url     = local.discourse_login_url
  discourse_signup_url    = local.discourse_signup_url
  discourse_url           = local.discourse_url
  discourse_username      = var.discourse_username
  discourse_api_key       = var.discourse_api_key
  member_hub_url          = var.member_hub_url
  cors_origins            = var.cors_origins
  cookie_domain           = var.cookie_domain
  ga_measurement_id       = var.ga_measurement_id
  mail_from               = var.mail_from
  recaptcha_secret_key    = var.recaptcha_secret_key
  recaptcha_site_key      = var.recaptcha_site_key
  redis_url               = local.redis_url
  sentry_dsn              = var.sentry_dsn
  skylight_authentication = var.skylight_authentication
  smtp_address            = var.smtp_address
  smtp_domain             = var.smtp_domain
  smtp_password           = var.smtp_password
  smtp_port               = var.smtp_port
  smtp_username           = var.smtp_username
  sso_cookie_name         = local.sso_cookie_name
  sso_jwt_secret          = local.sso_jwt_secret
  stripe_publishable_key  = var.stripe_publishable_key
  stripe_secret_key       = var.stripe_secret_key
}
