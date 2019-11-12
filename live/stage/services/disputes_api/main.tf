terraform {
  required_version = ">=0.12.13"

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

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "disputes_api" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "disputes-api-${local.environment}"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "disputes_api" {
  source      = "../../../../modules/services/disputes_api"
  environment = local.environment

  domain         = aws_route53_record.disputes_api.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  database_url  = local.database_url
  introspection = local.introspection
}
