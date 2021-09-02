variable "directus_key" {
  description = "Directus key"
}

variable "directus_secret" {
  description = "Directus secret"
}

variable "admin_email" {
  description = "Directus admin email"
}

variable "admin_password" {
  description = "Directus admin password"
}

variable "public_url" {
  description = "Directus public-facing url"
  default = "https://directus.debtcollective.org"
}