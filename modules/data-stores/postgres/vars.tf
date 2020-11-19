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

variable "vpc_id" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "allocated_storage" {
  default = 20
}

variable "subnet_ids" {
  type = list
}

variable "vpc_security_group_ids" {
  type = list
}

variable "skip_final_snapshot" {
  default = false
}
