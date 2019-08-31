resource "random_string" "fundraising_db_user" {
  length           = 8
  special          = true
  override_special = "/@\" "
}

resource "random_password" "fundraising_db_pass" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

resource "postgresql_role" "fundraising" {
  name     = "fundraising_${random_string.fundraising_db_user.result}"
  login    = true
  password = random_password.fundraising_db_pass.result
}

resource "postgresql_database" "fundraising" {
  name  = "fundraising_${local.environment}"
  owner = "fundraising_${random_string.fundraising_db_user.result}"
}
