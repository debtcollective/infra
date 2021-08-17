terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-mysql"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

module "mysql" {
  source      = "../../../../modules/data-stores/mysql"
  environment = "test"

  instance_class         = "db.t3.micro"
  subnet_ids             = local.subnet_ids
  vpc_id                 = local.vpc_id
  vpc_security_group_ids = local.vpc_security_group_ids
}
