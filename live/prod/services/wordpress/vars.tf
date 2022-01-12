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

variable "community_url" {
  description = "Community URL for header"
}

variable "wordpress_url" {
  description = "Wordpress URL for header menu api"
}

variable "return_url" {
  description = "Return URL for header"
}
