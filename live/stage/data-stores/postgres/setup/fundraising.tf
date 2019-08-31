resource "random_string" "username" {
  length           = 8
  special          = true
  override_special = "/@\" "
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

resource "postgresql_role" "fundraising" {
  name     = "fundraising_${random_string.username.result}"
  login    = true
  password = random_password.password.result
}

resource "postgresql_database" "fundraising" {
  name  = "fundraising_${local.environment}"
  owner = "fundraising_${random_string.username.result}"
}
