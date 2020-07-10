variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/ghost-s3:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 512
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

// Ghost app variables
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

variable "mail_transport" {
  description = "Mail transport protocol"
  default = "SMTP"
}

variable "mail_host" {
  description = "Mail host"
}

variable "mail_port" {
  description = "Mail port"
}

variable "mail_user" {
  description = "Mail user"
}

variable "mail_pass" {
  description = "Mail password"
}

variable "mail_from" {
  description = "Mail default from address"
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