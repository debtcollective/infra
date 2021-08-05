data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.iam_remote_state_workspace
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = local.remote_state_organization

    workspaces = {
      name = local.vpc_remote_state_workspace
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

locals {
  environment = "prod"

  ec2_security_group_ids  = [data.terraform_remote_state.vpc.outputs.ec2_security_group_id]
  elb_security_group_ids  = [data.terraform_remote_state.vpc.outputs.elb_security_group_id]
  iam_instance_profile_id = data.terraform_remote_state.iam.outputs.instance_profile_id
  instance_type           = "t3a.small"
  asg_max_size            = 6
  asg_desired_count       = 5
  key_name                = data.terraform_remote_state.vpc.outputs.ssh_key_pair_name
  subnet_ids              = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id

  slack_topic_arn = data.terraform_remote_state.notify_slack.outputs.slack_topic_arn

  iam_remote_state_workspace          = "global-iam"
  remote_state_organization           = "debtcollective"
  vpc_remote_state_workspace          = "${local.environment}-network"
  notify_slack_remote_state_workspace = "${local.environment}-extras-notify-slack"
}
