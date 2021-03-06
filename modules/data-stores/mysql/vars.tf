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
  default = "db.t3.micro"
}

variable "subnet_ids" {
  type = list
}

variable "vpc_security_group_ids" {
  type = list
}

variable "allocated_storage" {
  default     = "30"
  description = "Disk space for the database"
}
