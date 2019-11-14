variable "environment" {
  description = "Environment name"
}

variable "container_image" {
  description = "Docker image name"
  default     = "debtcollective/campaign-api:latest"
}

variable "container_memory_reservation" {
  description = "Memory reservation for containers"
  default     = 115
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

// campaign-api variables
variable "database_url" {
  description = "Postgres database URL"
}

variable "introspection" {
  description = "GraphQL introspection"
}
