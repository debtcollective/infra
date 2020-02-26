data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.vpc_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.cluster_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "postgres" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.postgres_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "postgres_setup" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.postgres_setup_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "notify_slack" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.notify_slack_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "s3" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.s3_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "redis" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.redis_remote_state_workspace
    }
  }
}

data "aws_ssm_parameter" "db_user" {
  name = data.terraform_remote_state.postgres_setup.outputs.discourse_db_user_ssm_key
}

data "aws_ssm_parameter" "db_pass" {
  name = data.terraform_remote_state.postgres_setup.outputs.discourse_db_pass_ssm_key
}

locals {
  environment = "prod"

  acm_certificate_domain     = "*.debtcollective.org"
  subdomain                  = "community"
  domain                     = "debtcollective.org"
  fqdn                       = "${local.subdomain}.debtcollective.org"
  s3_origin_id               = "discourse-${local.environment}"
  ec2_origin_id              = "discourse-assets-origin-${local.environment}"
  uploads_bucket_name        = "discourse-uploads-${local.environment}"
  uploads_bucket_replica_arn = data.terraform_remote_state.s3.outputs.discourse_uploads_replica_bucket_arn
  replication_role_arn       = data.terraform_remote_state.s3.outputs.replication_role_arn
  backups_bucket_name        = "discourse-backups-${local.environment}"
  cdn_alias                  = "community-cdn-${local.environment}"
  s3_cdn_url                 = "https://${aws_route53_record.cdn.fqdn}"
  sso_cookie_name            = "tdc_auth_production"

  db_address = data.terraform_remote_state.postgres.outputs.db_address
  db_name    = data.terraform_remote_state.postgres_setup.outputs.discourse_db_name
  db_pass    = data.aws_ssm_parameter.db_pass.value
  db_port    = data.terraform_remote_state.postgres.outputs.db_port
  db_user    = data.aws_ssm_parameter.db_user.value

  redis_host = data.terraform_remote_state.redis.outputs.host
  redis_port = data.terraform_remote_state.redis.outputs.port

  ssh_key_pair_name     = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id             = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  ec2_security_group_id = data.terraform_remote_state.vpc.outputs.ec2_security_group_id
  instance_type         = "t3a.small"

  slack_topic_arn = data.terraform_remote_state.notify_slack.outputs.slack_topic_arn

  cluster_remote_state_workspace        = "${local.environment}-cluster"
  iam_remote_state_workspace            = "global-iam"
  notify_slack_remote_state_workspace   = "${local.environment}-extras-notify-slack"
  postgres_remote_state_workspace       = "${local.environment}-postgres"
  postgres_setup_remote_state_workspace = "${local.environment}-postgres-setup"
  redis_remote_state_workspace          = "${local.environment}-redis"
  remote_state_organization             = "debtcollective"
  s3_remote_state_workspace             = "${local.environment}-extras-s3"
  vpc_remote_state_workspace            = "${local.environment}-network"
}
