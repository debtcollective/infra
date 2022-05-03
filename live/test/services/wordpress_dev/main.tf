terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "dev-services-wordpress"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "wordpress_dev" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "wordpress-dev"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "wordpress_dev" {
  source      = "../../../../modules/services/wordpress_dev"
  environment = local.environment

  domain                = aws_route53_record.wordpress_dev.fqdn
  ecs_cluster_id        = local.ecs_cluster_id
  lb_listener_id        = local.lb_listener_id
  vpc_id                = local.vpc_id
  subnet_id             = local.subnet_id
  ec2_security_group_id = local.ec2_security_group_id
  execution_role_arn    = local.execution_role_arn

  db_host             = local.db_host
  db_name             = local.db_name
  db_password_ssm_key = local.db_password_ssm_key
  db_username_ssm_key = local.db_username_ssm_key
  
  community_url = var.community_url
  wordpress_url = var.wordpress_url
  return_url    = var.return_url

  s3_access_key_id     = aws_iam_access_key.wordpress_dev.id
  s3_secret_access_key = aws_iam_access_key.wordpress_dev.secret
  s3_bucket            = aws_s3_bucket.uploads.id
  s3_region            = aws_s3_bucket.uploads.region
  cdn_url              = "https://${aws_route53_record.cdn.fqdn}"
}