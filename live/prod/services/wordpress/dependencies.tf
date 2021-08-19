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

data "terraform_remote_state" "mysql" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.mysql_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "mysql_setup" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.mysql_setup_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.iam_remote_state_workspace
    }
  }
}

locals {
  environment = "prod"

  db_host               = data.terraform_remote_state.mysql.outputs.db_address
  db_name               = data.terraform_remote_state.mysql_setup.outputs.wordpress_db_name
  db_username_ssm_key   = data.terraform_remote_state.mysql_setup.outputs.wordpress_db_user_ssm_key
  db_password_ssm_key   = data.terraform_remote_state.mysql_setup.outputs.wordpress_db_pass_ssm_key
  subnet_id             = data.terraform_remote_state.vpc.outputs.private_subnet_ids[0]
  ec2_security_group_id = data.terraform_remote_state.vpc.outputs.ec2_security_group_id

  ecs_cluster_id     = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  lb_dns_name        = data.terraform_remote_state.cluster.outputs.lb_dns_name
  lb_listener_id     = data.terraform_remote_state.cluster.outputs.lb_listener_id
  lb_zone_id         = data.terraform_remote_state.cluster.outputs.lb_zone_id
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  execution_role_arn = data.terraform_remote_state.iam.outputs.instance_role_arn

  cluster_remote_state_workspace     = "${local.environment}-cluster"
  iam_remote_state_workspace         = "global-iam"
  mysql_remote_state_workspace       = "${local.environment}-mysql"
  mysql_setup_remote_state_workspace = "${local.environment}-mysql-setup"
  remote_state_organization          = "debtcollective"
  vpc_remote_state_workspace         = "${local.environment}-network"

  acm_certificate_domain = "*.debtcollective.org"
  cdn_alias              = "wordpress-cdn-${local.environment}"
  domain                 = "debtcollective.org"
  s3_origin_id           = "wordpress-${local.environment}"
  uploads_bucket_name    = "wp-uploads-${local.environment}"
}
