terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-app-discourse"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = local.domain
}

resource "aws_route53_record" "discourse" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.subdomain
  type    = "A"
  ttl     = 300
  records = [module.discourse.public_ip]
}

module "discourse" {
  source      = "../../../../modules/services/discourse"
  environment = local.environment

  domain             = local.fqdn
  s3_cdn_url         = local.s3_cdn_url
  cdn_url            = aws_cloudfront_distribution.assets.domain_name
  discourse_hostname = local.fqdn

  monitoring      = true
  slack_topic_arn = local.slack_topic_arn

  discourse_smtp_address  = var.discourse_smtp_address
  discourse_smtp_username = var.discourse_smtp_username
  discourse_smtp_password = var.discourse_smtp_password

  discourse_db_host     = local.db_address
  discourse_db_name     = local.db_name
  discourse_db_username = local.db_user
  discourse_db_password = local.db_pass
  discourse_sso_secret  = var.discourse_sso_secret

  discourse_reply_by_email_address = var.discourse_reply_by_email_address
  discourse_pop3_polling_username  = var.discourse_pop3_polling_username
  discourse_pop3_polling_password  = var.discourse_pop3_polling_password
  discourse_pop3_polling_host      = var.discourse_pop3_polling_host
  discourse_pop3_polling_port      = var.discourse_pop3_polling_port

  discourse_ga_universal_tracking_code = var.discourse_ga_universal_tracking_code
  discourse_maxmind_license_key        = var.discourse_maxmind_license_key

  discourse_uploads_bucket_name   = aws_s3_bucket.uploads.id
  discourse_uploads_bucket_region = aws_s3_bucket.uploads.region
  discourse_backups_bucket_name   = aws_s3_bucket.backups.id
  discourse_backups_bucket_region = aws_s3_bucket.backups.region

  discourse_aws_access_key_id     = aws_iam_access_key.discourse.id
  discourse_aws_secret_access_key = aws_iam_access_key.discourse.secret

  discourse_sso_cookie_name = local.sso_cookie_name

  volume_size = 30

  key_name        = local.ssh_key_pair_name
  subnet_id       = local.subnet_id
  security_groups = local.ec2_security_group_id

}
