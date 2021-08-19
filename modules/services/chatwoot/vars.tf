/* ECS */
variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "chatwoot/chatwoot:latest"
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

/*
 * Chatwoot env variables
 */

/* App */
variable "frontend_url" {
  description = "Front-end full URL"
}

variable "default_locale" {
  description = "Default locale"
  default     = "en"
}

variable "database_url" {
  description = "Postgres schema URL"
}

variable "rails_env" {
  description = "Rails environment"
  default     = "production"
}

variable "secret_key_base" {
  description = "Secret key for sessions"
}

variable "log_level" {
  description = "Log level for the app"
  default     = "info"
}

variable "rails_log_to_stdout" {
  description = "Log to stdout"
  default     = true
}

/* Email */
variable "mailer_sender_email" {
  description = "Email from"
}

variable "smtp_address" {
  description = "SMTP address"
}

variable "smtp_username" {
  description = "SMTP username"
}

variable "smtp_password" {
  description = "SMTP password"
}

variable "smtp_authentication" {
  description = "SMTP authentication mode"
  default     = "plain"
}

variable "smtp_domain" {
  description = "SMTP domain"
}

variable "smtp_enable_starttls_auto" {
  description = "SMTP TLS"
  default     = true
}

variable "smtp_port" {
  description = "SMTP port"
  default     = "587"
}

variable "mailgun_ingress_api_key" {
  description = "Mailgun ingress signing key"
}

/* Push notifications */
variable "vapid_public_key" {
  description = "VAPID public key"
}

variable "vapid_private_key" {
  description = "VAPID private key"
}

/* Storage, we use AWS S3 */
variable "s3_bucket_name" {
  description = "AWS S3 bucket name"
}

variable "aws_access_key_id" {
  description = "AWS S3 access key id"
}

variable "aws_secret_access_key" {
  description = "AWS S3 secret access key"
}

variable "aws_region" {
  description = "AWS S3 region"
}

/* Redis */
variable "redis_url" {
  description = "Redis URL in redis uri scheme"
}

/* Slack */
variable "slack_client_id" {
  description = "Slack app client id"
}

variable "slack_client_secret" {
  description = "Slack app client secret id"
}

/* Sentry */
variable "sentry_dsn" {
  description = "Sentry.io DSN"
}

/* MaxMind Geolocation */
variable "ip_lookup_service" {
  description = "Ip lookup service"
  default     = "geoip2"
}

variable "ip_lookup_api_key" {
  description = "Ip lookup api_key"
}

/* Channels */
