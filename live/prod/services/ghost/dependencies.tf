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

data "aws_ssm_parameter" "db_user" {
  name = data.terraform_remote_state.mysql_setup.outputs.ghost_db_user_ssm_key
}

data "aws_ssm_parameter" "db_pass" {
  name = data.terraform_remote_state.mysql_setup.outputs.ghost_db_pass_ssm_key
}

locals {
  environment = "prod"

  db_host     = data.terraform_remote_state.mysql.outputs.db_address
  db_name     = data.terraform_remote_state.mysql_setup.outputs.ghost_db_name
  db_password = data.aws_ssm_parameter.db_pass.value
  db_username = data.aws_ssm_parameter.db_user.value

  ecs_cluster_id = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  lb_dns_name    = data.terraform_remote_state.cluster.outputs.lb_dns_name
  lb_listener_id = data.terraform_remote_state.cluster.outputs.lb_listener_id
  lb_zone_id     = data.terraform_remote_state.cluster.outputs.lb_zone_id
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id

  cluster_remote_state_workspace     = "${local.environment}-cluster"
  iam_remote_state_workspace         = "global-iam"
  mysql_remote_state_workspace       = "${local.environment}-mysql"
  mysql_setup_remote_state_workspace = "${local.environment}-mysql-setup"
  remote_state_organization          = "debtcollective"
  vpc_remote_state_workspace         = "${local.environment}-network"
}
