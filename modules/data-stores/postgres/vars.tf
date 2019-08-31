variable "remote_state_organization" {
  default = "debtcollective"
  type    = string
}

variable "vpc_remote_state_workspace" {
  type = string
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
