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

// Redis Configuration
variable "discourse_redis_host" {
  description = "Discourse redis host"
}

variable "discourse_redis_port" {
  description = "Discourse redis port"
  default     = "6379"
}

variable "discourse_letsencrypt_account_email" {
  description = "email to setup Let's Encrypt"
  default     = "orlando@debtcollective.org"
}

variable "discourse_sso_secret" {
  description = "SSO secret for Discourse"
}

variable "discourse_sso_cookie_name" {
  description = "SSO cookie name"
}

variable "discourse_sso_cookie_domain" {
  description = "SSO cookie domain"
  default     = ".debtcollective.org"
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

variable "swap_size" {
  description = "Size of swap in GBs"
  default     = "4G"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3a.small"
}

variable "volume_size" {
  description = "EBS block size"
  default     = 30
}

variable "monitoring" {
  description = "If true, enables Cloudwatch Detailed Monitoring for the EC2 instance"
  default     = false
}

variable "slack_topic_arn" {
  description = "Slack SNS topic ARN used for Cloudwatch alerts"
  default     = ""
}

variable "domain" {
  description = "Fully Qualified Domain Name"
}

variable "s3_cdn_url" {
  description = "Uploads CDN URL. ex: https://cdn-uploads.debtcollective.org"
}

variable "cdn_url" {
  description = "Assets CDN URL. ex: https://cdn-assets.debtcollective.org"
}

variable "discourse_uploads_bucket_name" {
  description = "Uploads S3 bucket name"
}

variable "discourse_uploads_bucket_region" {
  description = "Uploads S3 bucket region"
}

variable "discourse_backups_bucket_name" {
  description = "Backups S3 bucket name"
}

variable "discourse_backups_bucket_region" {
  description = "Backups S3 bucket region"
}

variable "discourse_aws_access_key_id" {
  description = "AWS access key id for S3 uploads"
}

variable "discourse_aws_secret_access_key" {
  description = "AWS access key secret for S3 uploads"
}

variable "skylight_authentication" {
  description = "skylight.io api key"
  default     = ""
}
