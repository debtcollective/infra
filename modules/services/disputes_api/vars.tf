variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/disputes-api:latest"
}

variable "key_name" {
  description = "SSH Key Pair to be assigned to the Launch Configuration for the instances running in this cluster"
}

variable "iam_instance_profile_id" {
  description = "IAM Profile ID to be used in the Launch Configuration for the instances running in this cluster"
}

variable "subnet_ids" {
  description = "VPC Subnet IDs to be used in the Launch Configuration for the instances running in this cluster"
  type        = "list"
}

variable "security_groups" {
  description = "VPC Security Groups IDs to be used in the Launch Configuration for the instances running in this cluster"
  type        = "list"
}

variable "asg_min_size" {
  description = "Auto Scaling Group minimium size for the cluster"
  default     = 1
}

variable "asg_max_size" {
  description = "Auto Scaling Group maximum size for the cluster"
  default     = 2
}

variable "desired_count" {
  description = "Number of instances to be run"
  default     = 1
}

variable "vpc_id" {
  description = "VPC id to be used by the LB"
}

variable "lb_listener_id" {
  description = "LB listener id"
}

variable "ecs_cluster_id" {
  description = "ECS cluster id where the app will run"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name where the app will run"
}

variable "domain" {
  description = "FQDN where app will be available"
}

variable "instance_type" {
  description = "Instance type Launch Configuration"
  default     = "t3a.micro"
}

// disputes-api variables
variable "database_url" {
  description = "Postgres database URL"
}

variable "introspection" {
  description = "GraphQL introspection"
}
