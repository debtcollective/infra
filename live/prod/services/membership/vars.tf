// Membership app variables
variable "discourse_username" {
  description = "Discourse API username"
}

variable "discourse_api_key" {
  description = "Discourse API key"
}

variable "member_hub_url" {
  description = "Member Hub URL"
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

variable "stripe_secret_key" {
  description = "Stripe secret key"
}

variable "stripe_publishable_key" {
  description = "Stripe publishable key"
}

variable "sentry_dsn" {
  description = "Sentry DSN"
}

variable "amplitude_api_key" {
  description = "Amplitude API key"
}

variable "ga_measurement_id" {
  description = "Google Analytics UA-XXXXX-Y"
}

// Skylight
variable "skylight_authentication" {
  description = "skylight.io api key"
  default     = ""
}

// SMTP
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
