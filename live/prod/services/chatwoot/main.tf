terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-services-chatwoot"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "chatwoot" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "chatwoot"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = false
  }
}

module "chatwoot" {
  source      = "../../../../modules/services/chatwoot"
  environment = local.environment

  domain                       = aws_route53_record.chatwoot.fqdn
  ecs_cluster_id               = local.ecs_cluster_id
  lb_listener_id               = local.lb_listener_id
  vpc_id                       = local.vpc_id
  container_memory_reservation = 256

  frontend_url    = "https://${aws_route53_record.chatwoot.fqdn}"
  database_url    = "postgres://${local.db_username}:${urlencode(local.db_password)}@${local.db_host}:${local.db_port}/${local.db_name}"
  secret_key_base = var.secret_key_base

  mailer_sender_email = var.mailer_sender_email
  smtp_address        = var.smtp_address
  smtp_username       = var.smtp_username
  smtp_password       = var.smtp_password
  smtp_domain         = var.smtp_domain

  vapid_public_key  = var.vapid_public_key
  vapid_private_key = var.vapid_private_key

  s3_bucket_name        = aws_s3_bucket.uploads.id
  aws_access_key_id     = aws_iam_access_key.chatwoot.id
  aws_secret_access_key = aws_iam_access_key.chatwoot.secret
  aws_region            = aws_s3_bucket.uploads.region

  redis_url = local.redis_url
}
