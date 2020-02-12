terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-static"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "landing" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = var.landing_cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "power_report" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "powerreport"
  type    = "A"

  alias {
    name                   = var.power_report_cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}
