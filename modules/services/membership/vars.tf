variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/membership:latest"
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

variable "mail_from" {
  description = "Reply to address used in emails sent from this app"
}

variable "smtp_address" {
  description = "SMTP address"
}

variable "smtp_port" {
  description = "SMTP port"
  default     = 587
}

variable "smtp_domain" {
  description = "SMTP domain"
}

variable "smtp_username" {
  description = "SMTP username"
}

variable "smtp_password" {
  description = "SMTP password"
}

variable "desired_count" {
  description = "Number of instances to be run"
  default     = 1
}

variable "log_retention_in_days" {
  description = "Cloudwatch logs retention"
  default     = 3
}

// Membership app variables
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

variable "discourse_url" {
  description = "Discourse URL"
}

variable "discourse_username" {
  description = "Discourse API username"
}

variable "discourse_api_key" {
  description = "Discourse API key"
}

variable "discourse_admin_role" {
  description = "Role with access to the admin backend"
  default     = "dispute_pro"
}

variable "home_page_url" {
  description = "Member Hub URL"
}

variable "login_page_url" {
  description = "Login Page URL"
}

variable "cors_origins" {
  description = "Allowed CORS origins"
}

variable "cookie_domain" {
  description = "Session Cookie domain"
}

variable "recaptcha_site_key" {
  description = "reCAPTCHA site key"
}

variable "recaptcha_secret_key" {
  description = "reCAPTCHA secret key"
}

variable "recaptcha_v3_secret_key" {
  description = "reCAPTCHA v3 secret key"
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

variable "sentry_environment" {
  description = "Sentry Environment"
}

variable "amplitude_api_key" {
  description = "Amplitude API key"
}

variable "ga_measurement_id" {
  description = "Google Analytics UA-XXXXX-Y"
}

variable "skylight_authentication" {
  description = "Skylight.io api key"
  default     = ""
}

variable "mailchimp_api_key" {
  description = "Mailchimp API key for newsletter integration"
}

variable "mailchimp_list_id" {
  description = "Mailchimp newsletter list id"
}

variable "algolia_app_id" {
  description = "Algolia places app id"
}

variable "algolia_api_key" {
  description = "Algolia places api key"
}
