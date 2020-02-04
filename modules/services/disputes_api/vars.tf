variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/disputes-api:latest"
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

// disputes-api variables
variable "database_url" {
  description = "Postgres database URL"
}

variable "introspection" {
  description = "GraphQL introspection"
}
