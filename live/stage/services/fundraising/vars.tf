variable "remote_state_organization" {
  default = "debtcollective"
  type    = string
}

variable "vpc_remote_state_workspace" {
  default = "stage-network"
  type    = string
}

variable "postgres_remote_state_workspace" {
  default = "stage-postgres"
  type    = string
}

variable "iam_remote_state_workspace" {
  default = "global-iam"
  type    = string
}
