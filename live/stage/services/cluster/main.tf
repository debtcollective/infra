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

// server working hours
resource "aws_autoscaling_schedule" "working_hours" {
  // disable it for now
  count                  = 0
  scheduled_action_name  = "working hours"
  min_size               = 1
  max_size               = 2
  desired_capacity       = 1
  recurrence             = "00 12 * * 1-5" #Mon-Fri at 7AM EST
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
}

// turn off servers at night
resource "aws_autoscaling_schedule" "off_working_hours" {
  // disable it for now
  count                  = 0
  scheduled_action_name  = "off working hours"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "00 03 * * 1-5" #Mon-Fri at 10PM EST
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
}
