variable "frontend_url" {
  description = "Angular frontend URL"
  default = "https://efile.debtcollective.org"
}

variable "client_id" {
  description = "Infotrack Client ID"
}

variable "client_secret" {
  description = "Infotrack Client Secret"
}

variable "session_secret" {
  description = "Session secret"
  default = "testing"
}