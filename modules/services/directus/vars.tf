variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "directus/directus:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 1024
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

// Directus app variables
variable "db_host" {
  description = "Database Host URL"
}

variable "db_username" {
  description = "Database Username"
}

variable "db_password" {
  description = "Database Password"
}

variable "db_port" {
  description = "Database Port"
  default     = "5432"
}

variable "db_name" {
  description = "Database name"
  default     = "directus"
}

variable "directus_key" {
  description = "Directus key"
}

variable "directus_secret" {
  description = "Directus secret"
}

variable "cache_enabled" {
  description = "Boolean to enable or disable caching"
  default = "true"
}

variable "cache_store" {
  description = "Cache store service"
  default = "redis"
}

variable "cache_redis" {
  description = "Redis Host URL"
}

variable "admin_email" {
  description = "Directus admin email"
}

variable "admin_password" {
  description = "Directus admin password"
}

variable "public_url" {
  description = "Directus public-facing url"
  default = "directus.debtcollective.org"
}