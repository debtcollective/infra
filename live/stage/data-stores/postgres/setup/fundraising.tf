// Generate random username and password
resource "random_string" "fundraising_db_user" {
  length  = 16
  special = false
}

resource "random_password" "fundraising_db_pass" {
  length           = 20
  special          = true
  min_special      = 1
  override_special = "~*$^\\"
}

// Store both in SSM
resource "aws_ssm_parameter" "fundraising_db_user" {
  name  = "/${local.environment}/services/fundraising/db_user"
  type  = "String"
  value = "fundraising_${random_string.fundraising_db_user.result}"
}

resource "aws_ssm_parameter" "fundraising_db_pass" {
  name  = "/${local.environment}/services/fundraising/db_pass"
  type  = "SecureString"
  value = random_password.fundraising_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "fundraising" {
  name                = aws_ssm_parameter.fundraising_db_user.value
  login               = true
  password            = aws_ssm_parameter.fundraising_db_pass.value
  skip_reassign_owned = true
}

resource "postgresql_database" "fundraising" {
  name  = "fundraising_${local.environment}"
  owner = aws_ssm_parameter.fundraising_db_user.value
}
