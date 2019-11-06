variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "freecodecamp/mail-for-good:latest"
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
  default     = 1
}

variable "desired_count" {
  description = "Number of instances to be run"
  default     = 1
}

variable "acm_certificate_domain" {
  description = "ACM certificate domain name to be used for SSL"
  default     = "*.debtcollective.org"
}

variable "vpc_id" {
  description = "VPC Id to be used by the LB"
}

variable "elb_security_groups" {
  description = "VPC Security Groups IDs to be used by the load balancer"
}

variable "instance_type" {
  description = "Instance type Launch Configuration"
  default     = "t3.micro"
}

// Mail for good app variables
variable "db_user" {
  description = "Postgres database user"
}

variable "db_pass" {
  description = "Postgres database password"
}

variable "db_name" {
  description = "Postgres database name"
}

variable "db_host" {
  description = "Postgres database host"
}

variable "redis_host" {
  description = "Redis host"
}

variable "redis_port" {
  description = "Redis port"
  default     = "6379"
}

variable "domain" {
  description = "Fully Qualified Domain Name"
}

variable "amazon_access_key_id" {
  description = "AWS SES access key"
}

variable "amazon_secret_access_key" {
  description = "AWS SES secret key"
}
