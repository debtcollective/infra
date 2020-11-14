variable "discourse_developer_emails" {
  description = "Discourse developer emails for notifications"
  default     = "orlando@debtcollective.org"
}

variable "discourse_smtp_authentication" {
  description = "Discourse SMTP authentication"
  default     = "plain"
}

variable "discourse_letsencrypt_account_email" {
  description = "email to setup Let's Encrypt"
  default     = "orlando@debtcollective.org"
}

variable "discourse_reply_by_email_address" {
  description = "Reply by email address, needs %%{reply_key} variable to be in the value"
}

variable "discourse_pop3_polling_username" {
  description = "pop3 username for the address used in reply by email"
}

variable "discourse_pop3_polling_password" {
  description = "pop3 password for the address used in reply by email"
}

variable "discourse_pop3_polling_host" {
  description = "pop3 host for the address used in reply by email"
}

variable "discourse_pop3_polling_port" {
  description = "pop3 port for the address used in reply by email"
}

variable "discourse_ga_universal_tracking_code" {
  description = "Google analytics universal tracking code"
}

variable "discourse_maxmind_license_key" {
  description = "Maxmind geo2ip database license key"
}

// SMTP configuration
variable "discourse_smtp_address" {
  description = "Discourse SMTP address"
}

variable "discourse_smtp_port" {
  description = "Discourse SMTP port"
  default     = 587
}

variable "discourse_smtp_username" {
  description = "Discourse SMTP user name"
}

variable "discourse_smtp_password" {
  description = "Discourse SMTP password"
}

variable "discourse_smtp_enable_start_tls" {
  description = "Discourse SMTP enable start TLS"
  default     = true
}
