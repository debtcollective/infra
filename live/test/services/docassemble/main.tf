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
  name    = "abolition-tools-${local.environment}"
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

  domain                       = aws_route53_record.docassemble.fqdn
  ecs_cluster_id               = local.ecs_cluster_id
  lb_listener_id               = local.lb_listener_id
  vpc_id                       = local.vpc_id
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu

  db_backups  = var.db_backups
  db_host     = local.db_address
  db_name     = local.db_name
  db_password = local.db_pass
  db_user     = local.db_user
  db_port     = local.db_port

  timezone          = var.timezone
  secretkey         = var.secretkey
  pythonpackages    = var.pythonpackages
  default_interview = var.default_interview

  redis_url = local.redis_url

  s3_bucket            = aws_s3_bucket.uploads.id
  s3_access_key_id     = aws_iam_access_key.docassemble.id
  s3_secret_access_key = aws_iam_access_key.docassemble.secret
  s3_region            = aws_s3_bucket.uploads.region

  smtp_username = var.smtp_username
  smtp_password = var.smtp_password
  smtp_host     = var.smtp_host
  smtp_port     = var.smtp_port
}
