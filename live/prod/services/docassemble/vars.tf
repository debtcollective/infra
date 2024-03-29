variable "container_memory_reservation" {
  description = "Memory reservation for containers"
}

variable "container_cpu" {
  description = "Container CPUs to allocate"
}

/* Mail */
variable "smtp_username" {
  description = "Mailgun SMTP username"
}

variable "smtp_password" {
  description = "Mailgun SMTP password"
}

variable "smtp_host" {
  description = "Mailgun SMTP host"
}

variable "smtp_port" {
  description = "Mailgun SMTP port"
}

/* App */
variable "secretkey" {
  description = "Docassemble secret key"
}

variable "db_backups" {
  description = "Do db backups"
  default     = false
}

variable "timezone" {
  description = "App timezone"
  default     = "America/Los_Angeles"
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
