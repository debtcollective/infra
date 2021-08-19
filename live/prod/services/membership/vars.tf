// Membership app variables
variable "discourse_username" {
  description = "Discourse API username"
}

variable "discourse_api_key" {
  description = "Discourse API key"
}

variable "home_page_url" {
  description = "Home page URL"
}

variable "login_page_url" {
  description = "Login page URL"
}

variable "cors_origins" {
  description = "Allowed CORS origins"
}

variable "cookie_domain" {
  description = "Session Cookie domain"
}

variable "chatwoot_base_url" {
  description = "Chatwoot Base URL"
}

variable "chatwoot_token" {
  description = "Chatwoot Website Token"
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

variable "amplitude_api_key" {
  description = "Amplitude API key"
}

variable "ga_measurement_id" {
  description = "Google Analytics UA-XXXXX-Y"
}

variable "mailchimp_api_key" {
  description = "Mailchimp API key for newsletter integration"
}

variable "mailchimp_list_id" {
  description = "Mailchimp newsletter list id"
}

variable "skylight_authentication" {
  description = "skylight.io api key"
  default     = ""
}

variable "sentry_environment" {
  description = "Sentry Environment"
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

// Algolia
variable "algolia_app_id" {
  description = "Algolia places app id"
}

variable "algolia_api_key" {
  description = "Algolia places api key"
}
