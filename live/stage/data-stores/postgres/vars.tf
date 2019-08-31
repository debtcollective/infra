variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "vpc_remote_state_workspace" {
  default = "stage-network"
  type    = string
}
