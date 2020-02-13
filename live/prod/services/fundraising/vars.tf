// Fundraising app variables
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
