variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/dispute-tools:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 256
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

variable "domain" {
  description = "FQDN where app will be available"
}

variable "desired_count" {
  description = "Number of instances to be run"
  default     = 1
}

// dispute-tools variables
variable "redis_host" {
  description = "Redis host"
}

variable "redis_port" {
  description = "Redis port"
}

variable "sso_endpoint" {
  description = "SSO authentication endpoint"
}

variable "sso_secret" {
  description = "Shared secret for SSO"
}

variable "jwt_secret" {
  description = "Unshared secret for JWT encoding"
}

variable "sso_cookie_name" {
  description = "Name of session cookie"
}

variable "contact_email" {
  description = "Administrator contact email"
}

variable "sender_email" {
  description = "The FROM address for sending emails"
}

variable "disputes_bcc_address" {
  description = "Address to bcc for all dispute emails"
}

variable "smtp_host" {
  description = "SMTP host"
}

variable "smtp_port" {
  description = "SMTP port"
}

variable "smtp_secure" {
  description = "Whether SMTP should use SSL"
  default     = true
}

variable "smtp_user" {
  description = "SMTP user"
}

variable "smtp_pass" {
  description = "SMTP password"
}

variable "loggly_api_key" {
  description = "Loggly API key"
}

variable "stripe_private" {
  description = "Stripe private key"
}

variable "stripe_publishable" {
  description = "Stripe shared key"
}

variable "google_maps_api_key" {
  description = "Google maps API key"
}

variable "db_connection_string" {
  description = "Connection string to DB instance"
}

variable "db_pool_min" {
  description = "Database pool minimum"
  default     = 1
}

variable "db_pool_max" {
  description = "Database pool maximum"
  default     = 20
}

variable "discourse_base_url" {
  description = "Discourse instance base url"
}

variable "discourse_api_key" {
  description = "Discourse API key"
}

variable "discourse_api_username" {
  description = "Discourse API username to go with key"
}

variable "doe_disclosure_representatives" {}
variable "doe_disclosure_phones" {}
variable "doe_disclosure_relationship" {}
variable "doe_disclosure_address" {}
variable "doe_disclosure_city" {}
variable "doe_disclosure_state" {}
variable "doe_disclosure_zip" {}

variable "site_url" {
  description = "URL where the application is hosted"
}

variable "landing_page_url" {
  description = "URL where the landing page is hosted"
}

variable "sentry_endpoint" {
  description = "Sentry DNS for error reporting"
}

variable "static_assets_bucket_url" {
  description = "Debtcollective static assets bucket url"
  default     = "https://s3.amazonaws.com/tds-static"
}

variable "aws_upload_bucket" {
  description = "S3 bucket name to store uploads"
}

variable "aws_upload_bucket_region" {
  description = "Upload bucket region"
}

variable "aws_access_key_id" {
  description = "Access key to upload files to bucket defined in aws_upload_bucket"
}

variable "aws_secret_access_key" {
  description = "Access key to upload files to bucket defined in aws_upload_bucket"
}

variable "log_retention_in_days" {
  description = "Cloudwatch logs retention"
  default     = 3
}

variable "recaptcha_site_key" {
  description = "Google reCAPTCHA site key"
}

variable "recaptcha_secret_key" {
  description = "Google reCAPTCHA secret key"
}

variable "google_analytics_ua" {
  description = "Google Analytics UA code"
  default     = ""
}
