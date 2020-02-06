variable "environment" {
  description = "Environment"
}

variable "cluster_name" {
  description = "ECS cluster name"
}

variable "key_name" {
  description = "SSH Key Pair to be assigned to the Launch Configuration for the instances running in this cluster"
}

variable "iam_instance_profile_id" {
  description = "IAM Profile ID to be used in the Launch Configuration for the instances running in this cluster"
}

variable "instance_type" {
  description = "Instace type Launch Configuration for the instances running in this cluster"
  default     = "t3a.small"
}

variable "security_groups" {
  description = "VPC Security Groups IDs to be used in the Launch Configuration for the instances running in this cluster"
  type        = list
}

variable "asg_min_size" {
  description = "Auto Scaling Group minimium size for the cluster"
  default     = 1
}

variable "asg_max_size" {
  description = "Auto Scaling Group maximum size for the cluster"
  default     = 3
}

variable "asg_desired_count" {
  description = "Number of instances to be run"
  default     = 2
}

variable "subnet_ids" {
  description = "VPC subnets id to deploy instance on"
  type        = list
}

variable "tags" {
  description = "Tags to be passed to autoscaling group"
  default     = []
  type        = list
}
