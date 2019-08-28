data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    name = "debtcollective/stage-network"
  }
}

data "aws_subnet_ids" "default" {
  count = var.subnet_ids == null ? 1 : 0

  vpc_id = local.vpc_id

}

locals {
  pg_config = (
    var.mysql_config == null
    ? data.terraform_remote_state.db[0].outputs
    : var.mysql_config
  )

  vpc_id = data.terraform_remote_state.vpc.outputs.id

  subnet_ids = (
    var.subnet_ids == null
    ? data.aws_subnet_ids.default[0].ids
    : var.subnet_ids
  )
}
