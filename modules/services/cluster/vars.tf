variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "security_group_ids" {
  type = list
}

variable "acm_certificate_domain" {
  type = string
}

variable "monitoring" {
  description = "If true, enables Cloudwatch Container Insights for this cluster"
  default     = false
}

variable "slack_topic_arn" {
  description = "Slack SNS topic ARN used for Cloudwatch alerts"
  default     = ""
}
