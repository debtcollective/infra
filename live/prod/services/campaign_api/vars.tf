variable "sentry_dsn" {
  description = "Sentry DSN"
}

variable "discourse_badge_id" {
  description = "Discourse Badge ID"
}

variable "discourse_api_username" {
  description = "Discourse API Username"
}

variable "discourse_api_key" {
  description = "Discourse API Key"
}

variable "introspection" {
  description = "GraphQL introspection"
  default     = true
}

variable "playground" {
  description = "GraphQL playground"
  default     = false
}

variable "mailchimp_api_key" {
  description = "Mailchimp API key"
}

variable "mailchimp_list_id" {
  description = "Mailchimp list id"
}

variable "mailchimp_tag" {
  description = "Mailchimp tag"
}
