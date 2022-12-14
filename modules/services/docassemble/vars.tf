variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "jhpyle/docassemble@latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 3926
}
variable "container_cpu" {
  description = "Container CPUs to allocate"
  default     = 4096
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
/* Database */
variable "db_backups" {
  description = "Do db backups"
}

variable "db_host" {
  description = "Database host"
}

variable "db_port" {
  description = "Database port"
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

/* Mail */
variable "smtp_username" {
  description = "Mailgun SMTP username"
}

variable "smtp_password" {
  description = "Mailgun SMTP password"
}

variable "smtp_host" {
  description = "Mailgun SMTP host"
}

variable "smtp_port" {
  description = "Mailgun SMTP port"
}

variable "mail_from" {
  default = "'\"Administrator\" <no-reply@mg.evictiondefensetest.com>'"
}

variable "mail_lawyer" {
  default = "evictiondefensela@innercitylaw.org"
}

variable "mail_cc" {
  default = "evictiondefensela@debtcollective.org"
}

/* S3 */
variable "s3_bucket" {
  description = "AWS S3 bucket name"
}

variable "s3_access_key_id" {
  description = "AWS S3 access key"
}

variable "s3_secret_access_key" {
  description = "AWS S3 secret access key"
}

variable "s3_region" {
  description = "AWS S3 region"
}

/* Redis */
variable "redis_url" {
  description = "Redis URL schema (redis://host/db)"
}

/* App */
variable "timezone" {
  description = "App timezone"
  default     = "America/Los_Angeles"
}

variable "debug" {
  default = false
}

variable "secretkey" {
  description = "Docassemble secret key"
}

variable "default_interview" {
  description = "Docassemble default interview"
}

variable "pythonpackages" {
  description = "Interview packages to be installed, pass it in git url format. Ex. git+https://<access_token>@github.com/debtcollective/docassemble-evictiondefense.git@main"
}

variable "landing_url" {
  description = "Landing page URL"
  default     = "https://tenantpowertoolkit.org/"
}
