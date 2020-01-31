variable "environment" {
  description = "Environment name"
}

variable "discourse_hostname" {
  description = "Discourse hostname"
}

variable "discourse_developer_emails" {
  description = "Discourse developer emails for notifications"
  default     = "orlando@debtcollective.org"
}

// SMTP configuration
variable "discourse_smtp_address" {
  description = "Discourse SMTP address"
}

variable "discourse_smtp_port" {
  description = "Discourse SMTP port"
  default     = 587
}

variable "discourse_smtp_user_name" {
  description = "Discourse SMTP user name"
}

variable "discourse_smtp_password" {
  description = "Discourse SMTP password"
}

variable "discourse_smtp_enable_start_tls" {
  description = "Discourse SMTP enable start TLS"
  default     = true
}

variable "discourse_smtp_authentication" {
  description = "Discourse SMTP authentication"
  default     = "plain"
}

// Database Configuration
variable "discourse_db_host" {
  description = "Discourse database host URL"
}

variable "discourse_db_port" {
  description = "Discourse database port"
  default     = "5432"
}

variable "discourse_db_name" {
  description = "Discourse database name"
}

variable "discourse_db_username" {
  description = "Discourse database username"
}

variable "discourse_db_password" {
  description = "Discourse database password"
}

variable "discourse_letsencrypt_account_email" {
  description = "email to setup Let's Encrypt"
  default     = "orlando@hashlabs.com"
}

variable "discourse_sso_secret" {
  description = "SSO secret for Discourse"
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

variable "key_name" {
  description = "SSH Key Pair to be assigned to the instance"
}

variable "subnet_id" {
  description = "VPC Subnet ID to be used in by the instance"
}

variable "security_groups" {
  description = "VPC Security Groups IDs to be used by the instance"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3a.small"
}

variable "volume_size" {
  description = "EBS block size"
  default     = 20
}

variable "acm_certificate_domain" {
  description = "ACM certificate domain name to be used for CDN SSL"
  default     = "*.debtcollective.org"
}

variable "domain" {}
