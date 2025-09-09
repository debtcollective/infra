terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-efiling-backend"
    }
  }
}
provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "efiling_backend" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "infotrack"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "efiling_backend" {
  source      = "../../../../modules/services/efiling_backend"
  environment = local.environment

  domain         = aws_route53_record.efiling_backend.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  frontend_url   = var.frontend_url
  client_id      = var.client_id
  client_secret  = var.client_secret
  session_secret = var.session_secret
}
