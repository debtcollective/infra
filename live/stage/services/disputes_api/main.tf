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

  vpc_id                  = local.vpc_id
  lb_listener_id          = local.lb_listener_id
  ecs_cluster_id          = local.ecs_cluster_id
  ecs_cluster_name        = local.ecs_cluster_name
  key_name                = local.ssh_key_pair_name
  iam_instance_profile_id = local.iam_instance_profile_id
  subnet_ids              = local.subnet_ids
  security_groups         = [local.ec2_security_group_id]
  domain                  = aws_route53_record.disputes_api.fqdn

  database_url  = local.database_url
  introspection = local.introspection
}
