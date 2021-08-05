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
