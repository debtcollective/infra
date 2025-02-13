variable "container_memory_reservation" {
  description = "Memory reservation for containers"
}

variable "container_cpu" {
  description = "Container CPUs to allocate"
}

/* Mail */
variable "mailgun_api_url" {
  description = "Mailgun API URL"
}

variable "mailgun_api_key" {
  description = "Mailgun API key"
}

variable "mailgun_domain" {
  description = "Mailgun Domain"
}

variable "default_sender" {
  description = "Mailgun default sender"
}

/* App */
variable "secretkey" {
  description = "Docassemble secret key"
}

variable "db_backups" {
  description = "Do db backups"
  default     = false
}

variable "mail_cc" {
  description = "CC Email for Tools"
}

variable "mail_email_zapier" {
  description = "Zapier Email for Tools"
}

variable "mail_lawyer" {
  description = "Lawyer email for Tools"
}

variable "mail_lawyer_bail" {
  description = "Bail Lawyer email for Tools"
}

variable "mail_lawyer_student" {
  description = "Student Lawyer email for Tools"
}

variable "server_admin_email" {
  description = "Admin email for Tools"
}

variable "voicerss_key" {
  description = "Admin email for Tools"
}

variable "rabbitmq" {
  description = "Rabbitmq URL"
}

variable "landing_url" {
  description = "Landing page URL"
  default     = "https://evictiondefensela.org/"
}

variable "pythonpackages" {
  description = "Interview packages to be installed, pass it in git url format. Ex. git+https://<access_token>@github.com/debtcollective/docassemble-evictiondefense.git@main"
}

variable "default_interview" {
  description = "Docassemble default interview"
}
