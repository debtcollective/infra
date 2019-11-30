terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-app-campaign-api"
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

  database_url         = local.database_url
  discourse_login_url  = local.discourse_login_url
  discourse_signup_url = local.discourse_signup_url
  introspection        = local.introspection
  playground           = local.playground
  sso_cookie_name      = local.sso_cookie_name
  sso_jwt_secret       = local.sso_jwt_secret
  cors_origin          = local.cors_origin
  sentry_dsn           = var.sentry_dsn
}
