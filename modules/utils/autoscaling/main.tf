/**
 *## Description:
 *
 *Launch Configuration module creates a `aws_launch_configuration` resource with the provided variables.
 *
 *## Usage:
 *
 *```hcl
 *module "autoscaling" {
 *  source = "../utils/autoscaling"
 *  environment = var.environment
 *
 *  cluster_name            = aws_ecs_cluster.microservices.name
 *  key_name                = var.key_name
 *  iam_instance_profile_id = var.iam_instance_profile_id
 *  security_groups         = var.security_groups
 *  instance_type           = var.instance_type
 *  tags = [
 *    {
 *      key = "Terraform"
 *      value = true
 *      propagate_at_launch = true
 *    }
 *  ]
 *}
 *```
 */

locals {
  default_asg_tags = [
    {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = true
      propagate_at_launch = true
    },
  ]
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    environment  = var.environment
    cluster_name = var.cluster_name
  }
}

resource "aws_launch_configuration" "lc" {
  name_prefix          = "${var.environment}-lc-"
  iam_instance_profile = var.iam_instance_profile_id
  image_id             = data.aws_ami.ecs_ami.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = var.security_groups
  user_data            = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.lc.id
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.subnet_ids

  tags = concat(local.default_asg_tags, var.tags)
}
