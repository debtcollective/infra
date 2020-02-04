variable "environment" {
  description = "Environment"
}

variable "key_name" {
  description = "SSH Key Pair to be assigned to the Launch Configuration for the instances running in this cluster"
}

variable "instance_type" {
  description = "EC2 instance type for Bastion"
  default     = "t3a.nano"
}

variable "subnet_id" {
  description = "VPC Security Groups IDs to be used in the Launch Configuration for the instances running in this cluster"
}

variable "vpc_security_group_ids" {
  description = "VPC Security Groups IDs to be used in the Launch Configuration for the instances running in this cluster"
  type        = list
}
