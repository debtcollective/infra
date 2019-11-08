variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "security_group_ids" {
  type = list
}

variable "acm_certificate_domain" {
  type = string
}
