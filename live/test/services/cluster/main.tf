terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-cluster"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

module "cluster" {
  source      = "../../../../modules/services/cluster"
  environment = local.environment

  acm_certificate_domain = "*.debtcollective.org"
  security_group_ids     = local.elb_security_group_ids
  subnet_ids             = local.subnet_ids
  monitoring             = true
  slack_topic_arn        = local.slack_topic_arn
}

// Autoscaling and launch configurations for this cluster
module "autoscaling" {
  source      = "../../../../modules/utils/autoscaling"
  environment = local.environment

  cluster_name            = module.cluster.ecs_cluster_name
  iam_instance_profile_id = local.iam_instance_profile_id
  instance_type           = local.instance_type
  key_name                = local.key_name
  security_groups         = local.ec2_security_group_ids
  subnet_ids              = local.subnet_ids
  asg_max_size            = local.asg_max_size
  asg_desired_count       = local.asg_desired_count

  tags = [
    {
      key                 = "Name"
      value               = "${local.environment}_instance"
      propagate_at_launch = true
    },
  ]
}
