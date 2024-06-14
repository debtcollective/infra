variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtbot/wordpress-cli:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 2048
}

variable "vpc_id" {
  description = "VPC Id to be used by the LB"
}

variable "lb_listener_id" {
  description = "LB listener id"
}

variable "ecs_cluster_id" {
  description = "ECS cluster id where the app will run"
}

variable "ec2_security_group_id" {
  description = "EC2 Security group ID"
}

variable "domain" {
  description = "FQDN where app will be available"
}

variable "desired_count" {
  description = "Number of instances to be run"
  default     = 1
}

variable "log_retention_in_days" {
  description = "Cloudwatch logs retention"
  default     = 7
}

variable "execution_role_arn" {
  description = "Execution role for task definition, given we are using secrets it's needed"
}

// wordpress app variables
variable "db_host" {
  description = "Database Host URL"
}

variable "db_username_ssm_key" {
  description = "Database Username ssm key for encrypted secrets"
}

variable "db_password_ssm_key" {
  description = "Database Password ssm key for encrypted secrets"
}

variable "db_name" {
  description = "Database name"
}

variable "s3_access_key_id" {
  description = "AWS S3 Access key id"
}

variable "s3_secret_access_key" {
  description = "AWS S3 Secret access key"
}

variable "s3_bucket" {
  description = "AWS S3 Bucket"
}

variable "s3_region" {
  description = "AWS S3 bucket region"
}

variable "cdn_url" {
  description = "Cloudfront distribution URL to serve assets via CDN"
}

variable "subnet_id" {
  description = "VPC Subnet ID to be used in by the instance"
}

variable "community_url" {
  description = "Community URL for header"
}

variable "wordpress_url" {
  description = "Wordpress URL for header menu api"
}

variable "return_url" {
  description = "Return URL for header"
}
