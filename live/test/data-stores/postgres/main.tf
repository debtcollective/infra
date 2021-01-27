terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-postgres"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

module "postgres" {
  source      = "../../../../modules/data-stores/postgres"
  environment = "test"

  instance_class         = "db.t3.micro"
  subnet_ids             = local.subnet_ids
  vpc_id                 = local.vpc_id
  vpc_security_group_ids = local.vpc_security_group_ids
  allocated_storage      = 5
  skip_final_snapshot    = true
  engine_version         = "11.9"
}
