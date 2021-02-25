variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "jhpyle/docassemble:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 256
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
  default     = 3
}

// Docassemble app variables
variable "db_backup" {
  description = "Do db backups"
}

variable "db_host" {
  description = "Database host"
}

variable "db_name" {
  description = "Database name"
}

variable "db_password" {
  description = "Database password"
}

variable "db_user" {
  description = "Database user"
}

variable "s3_bucket" {
  description = "AWS S3 bucket name"
}

variable "timezone" {
  description = "App timezone"
  default = "America/Los_Angeles"
}
