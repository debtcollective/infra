variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "hissingpanda/efiling-backend:0.0.1"
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

variable "log_retention_in_days" {
  description = "Cloudwatch logs retention"
  default     = 3
}

// efiling backend node variables
variable "frontend_url" {
  description = "Angular frontend URL"
}

variable "client_id" {
  description = "Infotrack Client ID"
}

variable "client_secret" {
  description = "Infotrack Client Secret"
}

variable "session_secret" {
  description = "Session secret"
}