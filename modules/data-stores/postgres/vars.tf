variable "remote_state_organization" {
  default = "debtcollective"
  type    = string
}

variable "vpc_remote_state_workspace" {
  default = "stage-network"
  type    = string
}

variable "environment" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "vpc_security_group_ids" {
  type = list
}
