terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-services-ghost"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "ghost" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "ghost"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "ghost" {
  source      = "../../../../modules/services/ghost"
  environment = local.environment

  domain         = aws_route53_record.ghost.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  db_host     = local.db_host
  db_name     = local.db_name
  db_password = local.db_password
  db_username = local.db_username
}
