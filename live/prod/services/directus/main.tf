terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "prod-services-directus"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "directus" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "admin"
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}

module "directus" {
  source      = "../../../../modules/services/directus"
  environment = local.environment

  domain         = aws_route53_record.directus.fqdn
  ecs_cluster_id = local.ecs_cluster_id
  lb_listener_id = local.lb_listener_id
  vpc_id         = local.vpc_id

  db_host        = local.db_host
  db_name        = local.db_name
  db_password    = local.db_password
  db_port        = local.db_port
  db_username    = local.db_username

  directus_key    = var.directus_key
  directus_secret = var.directus_secret
  cache_store    = local.cache_store
  cache_redis    = local.cache_redis
  admin_email    = var.admin_email
  admin_password = var.admin_password
  public_url     = local.public_url

  aws_access_key_id     = aws_iam_access_key.directus.id
  aws_secret_access_key = aws_iam_access_key.directus.secret
  aws_region            = aws_s3_bucket.uploads.region
  storage_locations     = "s3"
  storage_s3_driver     = "s3"
  storage_s3_root       = ""
  storage_s3_key        = aws_iam_access_key.directus.id
  storage_s3_secret     = aws_iam_access_key.directus.secret
  storage_s3_bucket     = aws_s3_bucket.uploads.id
  storage_s3_region     = aws_s3_bucket.uploads.region
  storage_s3_acl        = aws_s3_bucket.uploads.acl

}
