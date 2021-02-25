terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-app-docassemble"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "docassemble" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "docassemble-test"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "docassemble" {
  source      = "../../../../modules/services/docassemble"
  environment = local.environment

  domain         = aws_route53_record.docassemble.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  db_backups = var.db_backups
  db_host = local.db_address
  db_name = local.db_name
  db_password = local.db_pass
  db_user = local.db_user

  timezone = var.timezone

  s3_bucket        = aws_s3_bucket.uploads.id
}
