terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-services-wordpress"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "wordpress-test"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "wordpress" {
  source      = "../../../../modules/services/wordpress"
  environment = local.environment

  domain                = aws_route53_record.wordpress.fqdn
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

  mail_from = var.mail_from
  mail_host = var.mail_host
  mail_pass = var.mail_pass
  mail_port = var.mail_port
  mail_user = var.mail_user
  
  dc_donate_api_url        = var.dc_donate_api_url
  dc_membership_api_url    = var.dc_membership_api_url
  dc_funds_api_url         = var.dc_funds_api_url
  dc_recaptcha_v3_site_key = var.dc_recaptcha_v3_site_key
  dc_stripe_public_token   = var.dc_stripe_public_token

  s3_access_key_id     = aws_iam_access_key.wordpress.id
  s3_secret_access_key = aws_iam_access_key.wordpress.secret
  s3_bucket            = aws_s3_bucket.uploads.id
  s3_region            = aws_s3_bucket.uploads.region
  cdn_url              = "https://${aws_route53_record.cdn.fqdn}"
}