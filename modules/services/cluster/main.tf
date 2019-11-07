/**
 *Cluster module creates a ECS cluster and a ALB to be used by apps and services in a specific environment
 *The cluster is created inside a VPC.
 *
 *This module creates all the necessary pieces that are needed to run a cluster, including:
 *
 ** Auto Scaling Groups
 ** EC2 Launch Configurations
 ** Application load balancer (ALB)
 *
 *## Usage:
 *
 *```hcl
 *module "cluster" {
 *  source      = "../cluster"
 *  environment = "${var.environment}"
 *
 *  security_groups_ids = var.security_groups
 *  subnet_ids = var.subnet_ids
 *}
 *```
 */
locals {
  name = "${var.environment}-alb"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.environment
}

resource "aws_lb" "lb" {
  name            = local.name
  security_groups = var.security_group_ids
  subnets         = var.subnet_ids

  tags = {
    Environment = var.environment
    Terraform   = true
  }
}
