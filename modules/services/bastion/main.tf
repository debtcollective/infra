/**
 *## Description:
 *
 *Bastion creates a EC2 instance to be used as Bastion host for our infrastructure
 *
 *## Usage:
 *
 *```hcl
 *module "bastion" {
 *  source = "../../modules/compute/utils/bastion"
 *
 *  environment            = var.environment
 *  key_name               = data.terraform_remote_state.base.ecs_key_name
 *  subnet_id              = module.vpc.public_subnet_ids[0]
 *  vpc_security_group_ids = [module.vpc.bastion_security_group_id]
 *}
 *```
 */

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
    environment = var.environment
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ecs_ami.id
  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name        = "bastion-${var.environment}"
    Class       = "terraform"
    Environment = var.environment
  }
}

resource "aws_eip" "bastion_eip" {
  vpc      = true
  instance = aws_instance.bastion.id
}
