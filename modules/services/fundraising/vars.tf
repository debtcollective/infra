variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/fundraising:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 115
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

// Fundraising app variables
variable "database_url" {
  description = "Postgres database URL"
}

variable "redis_url" {
  description = "Redis URL used for cache and Sidekiq"
}

variable "sso_cookie_name" {
  description = "SSO cookie name as defined in Discourse"
}

variable "sso_jwt_secret" {
  description = "SSO JWT secret as defined in Discourse"
}

variable "discourse_login_url" {
  description = "SSO login URL"
}

variable "discourse_signup_url" {
  description = "SSO signup URL"
}

variable "recaptcha_site_key" {
  description = "reCAPTCHA site key"
}

variable "recaptcha_secret_key" {
  description = "reCAPTCHA secret key"
}

variable "discourse_admin_role" {
  description = "Role with access to the admin backend"
  default     = "dispute_pro"
}

variable "stripe_secret_key" {
  description = "Stripe secret key"
}

variable "stripe_publishable_key" {
  description = "Stripe publishable key"
}

variable "sentry_dsn" {
  description = "Sentry DSN"
}
