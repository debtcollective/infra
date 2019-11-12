variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/fundraising:latest"
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
