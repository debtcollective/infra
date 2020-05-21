terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-app-campaign-api"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "campaign_api" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "campaign-api"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "campaign_api" {
  source      = "../../../../modules/services/campaign_api"
  environment = local.environment

  domain         = aws_route53_record.campaign_api.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  cors_origin            = local.cors_origin
  database_url           = local.database_url
  discourse_api_key      = var.discourse_api_key
  discourse_api_url      = local.discourse_uri
  discourse_api_username = var.discourse_api_username
  discourse_badge_id     = var.discourse_badge_id
  discourse_login_url    = local.discourse_login_url
  discourse_signup_url   = local.discourse_signup_url
  introspection          = var.introspection
  mailchimp_api_key      = var.mailchimp_api_key
  mailchimp_list_id      = var.mailchimp_list_id
  mailchimp_tag          = var.mailchimp_tag
  playground             = var.playground
  sentry_dsn             = var.sentry_dsn
  sso_cookie_name        = local.sso_cookie_name
  sso_jwt_secret         = local.sso_jwt_secret
}
