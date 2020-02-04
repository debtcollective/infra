variable "sso_secret" {
  description = "Shared secret for SSO"
}

variable "jwt_secret" {
  description = "Unshared secret for JWT encoding"
}

variable "contact_email" {
  description = "Administrator contact email"
}

variable "sender_email" {
  description = "The FROM address for sending emails"
}

variable "disputes_bcc_address" {
  description = "Address to bcc for all dispute emails"
}

variable "smtp_host" {
  description = "SMTP host"
}

variable "smtp_port" {
  description = "SMTP port"
}

variable "smtp_secure" {
  description = "Whether SMTP should use SSL"
  default     = true
}

variable "smtp_user" {
  description = "SMTP user"
}

variable "smtp_pass" {
  description = "SMTP password"
}

variable "loggly_api_key" {
  description = "Loggly API key"
}

variable "stripe_private" {
  description = "Stripe private key"
}

variable "stripe_publishable" {
  description = "Stripe shared key"
}

variable "google_maps_api_key" {
  description = "Google maps API key"
}

variable "db_pool_min" {
  description = "Database pool minimum"
  default     = 1
}

variable "db_pool_max" {
  description = "Database pool maximum"
  default     = 20
}

variable "discourse_api_key" {
  description = "Discourse API key"
}

variable "discourse_api_username" {
  description = "Discourse API username to go with key"
}

variable "doe_disclosure_representatives" {}
variable "doe_disclosure_phones" {}
variable "doe_disclosure_relationship" {}
variable "doe_disclosure_address" {}
variable "doe_disclosure_city" {}
variable "doe_disclosure_state" {}
variable "doe_disclosure_zip" {}

variable "sentry_endpoint" {
  description = "Sentry DNS for error reporting"
}

variable "aws_upload_bucket" {
  description = "S3 bucket name to store uploads"
}

variable "aws_upload_bucket_region" {
  description = "Upload bucket region"
}

variable "aws_access_key_id" {
  description = "Access key to upload files to bucket defined in aws_upload_bucket"
}

variable "aws_secret_access_key" {
  description = "Access key to upload files to bucket defined in aws_upload_bucket"
}

variable "log_retention_in_days" {
  description = "Cloudwatch logs retention"
  default     = 3
}

variable "recaptcha_site_key" {
  description = "Google reCAPTCHA site key"
}

variable "recaptcha_secret_key" {
  description = "Google reCAPTCHA secret key"
}

variable "google_analytics_ua" {
  description = "Google Analytics UA code"
  default     = ""
}
