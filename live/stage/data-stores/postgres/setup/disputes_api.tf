// Generate random username and password
resource "random_string" "disputes_api_db_user" {
  length  = 16
  special = false
}

resource "random_password" "disputes_api_db_pass" {
  length           = 20
  special          = true
  min_special      = 1
  override_special = "~*$^\\"
}

// Store both in SSM
resource "aws_ssm_parameter" "disputes_api_db_user" {
  name  = "/${local.environment}/services/disputes_api/db_user"
  type  = "String"
  value = "disputes_api_${random_string.disputes_api_db_user.result}"
}

resource "aws_ssm_parameter" "disputes_api_db_pass" {
  name  = "/${local.environment}/services/disputes_api/db_pass"
  type  = "SecureString"
  value = random_password.disputes_api_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "disputes_api" {
  name                = aws_ssm_parameter.disputes_api_db_user.value
  login               = true
  password            = aws_ssm_parameter.disputes_api_db_pass.value
  skip_reassign_owned = true
}

resource "postgresql_database" "disputes_api" {
  name  = "disputes_api_${local.environment}"
  owner = aws_ssm_parameter.disputes_api_db_user.value
}

resource postgresql_grant "disputes_api" {
  database    = postgresql_database.disputes_api.name
  role        = postgresql_role.disputes_api.name
  schema      = "public"
  object_type = "table"
  privileges  = ["ALL"]
}
