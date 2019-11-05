terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-service-mail-for-good"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "stage"
  domain      = "mfg"
  fqdn        = "mfg.debtcollective.org"
}

// Create user and access key
resource "aws_iam_user" "mfg" {
  name = "mfg_${local.environment}"
  path = "/service_accounts/${local.environment}/"

  tags = {
    Terraform = true
  }
}

resource "aws_iam_access_key" "mfg" {
  user    = aws_iam_user.mfg.name
  pgp_key = "keybase:orlando"
}


resource "aws_iam_user_policy" "mfg" {
  name = "mail_for_good"
  user = "${aws_iam_user.mfg.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:*",
        "ses:*",
        "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "mail_for_good" {
  source      = "../../../../modules/services/mail_for_good"
  environment = local.environment

  acm_certificate_domain  = local.acm_certificate_domain
  elb_security_groups     = [local.elb_security_group_id]
  vpc_id                  = local.vpc_id
  key_name                = local.ssh_key_pair_name
  iam_instance_profile_id = local.iam_instance_profile_id
  subnet_ids              = local.subnet_ids
  security_groups         = [local.ec2_security_group_id]

  db_user                  = local.db_user
  db_pass                  = local.db_pass
  db_host                  = local.db_address
  db_name                  = local.db_name
  domain                   = local.domain
  google_consumer_key      = local.google_consumer_key
  google_consumer_secret   = local.google_consumer_secret
  amazon_access_key_id     = aws_iam_access_key.mfg.id
  amazon_secret_access_key = aws_iam_access_key.mfg.secret
  redis_host               = local.redis_host
  redis_port               = local.redis_port
}

data "aws_route53_zone" "primary" {
  name = "debtcollective.org"
}

resource "aws_route53_record" "mail_for_good" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.domain
  type    = "A"

  alias {
    name                   = module.mail_for_good.dns_name
    zone_id                = module.mail_for_good.zone_id
    evaluate_target_health = true
  }
}
