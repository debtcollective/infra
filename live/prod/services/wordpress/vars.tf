variable "mail_transport" {
  description = "Mail transport protocol"
  default = "SMTP"
}

variable "mail_host" {
  description = "Mail host"
}

variable "mail_port" {
  description = "Mail port"
}

variable "mail_user" {
  description = "Mail user"
}

variable "mail_pass" {
  description = "Mail password"
}

variable "mail_from" {
  description = "Mail default from address"
}

variable "dc_donate_api_url" {
  description = "Membership app donation URL"
}

variable "dc_membership_api_url" {
  description = "Membership app membership URL"
}

variable "dc_funds_api_url" {
  description = "Membership app funds URL"
}

variable "dc_recaptcha_v3_site_key" {
  description = "Google recaptcha v3 Key"
}

variable "dc_stripe_public_token" {
  description = "Stripe public token"
}
