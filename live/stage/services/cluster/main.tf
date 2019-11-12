terraform {
  required_version = ">=0.12.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-cluster"
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

  tags = [
    {
      key                 = "Name"
      value               = "${local.environment}_instance"
      propagate_at_launch = true
    },
  ]
}
