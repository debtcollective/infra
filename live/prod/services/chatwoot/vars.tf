/* ECS */
/*
 * Chatwoot env variables
 */

/* App */
variable "secret_key_base" {
  description = "Secret key for sessions"
}

variable "log_level" {
  description = "Log level for the app"
  default     = "info"
}

/* Email */
variable "mailer_sender_email" {
  description = "Email from"
}

variable "smtp_address" {
  description = "SMTP address"
}

variable "smtp_username" {
  description = "SMTP username"
}

variable "smtp_password" {
  description = "SMTP password"
}

variable "smtp_domain" {
  description = "SMTP domain"
}

variable "smtp_port" {
  description = "SMTP port"
  default     = "587"
}

variable "mailgun_ingress_api_key" {
  description = "Mailgun ingress signing key"
}

/* Push notifications */
variable "vapid_public_key" {
  description = "VAPID public key"
}

variable "vapid_private_key" {
  description = "VAPID private key"
}

/* Slack */
variable "slack_client_id" {
  description = "Slack app client id"
}

variable "slack_client_secret" {
  description = "Slack app client secret id"
}

/* Sentry */
variable "sentry_dsn" {
  description = "Sentry.io DSN"
}
