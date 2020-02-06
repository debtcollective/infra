// Generate random username and password
resource "random_string" "disputes_api_db_user" {
  length  = 16
  special = false
}

resource "random_password" "disputes_api_db_pass" {
  length           = 20
  special          = true
  min_special      = 1
  override_special = "~*^+"
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
  roles               = [local.master_db_user]
  skip_reassign_owned = true
}

resource "postgresql_database" "disputes_api" {
  name       = "disputes_api_${local.environment}"
  owner      = local.master_db_user
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
  encoding   = "UTF8"
}

resource "postgresql_default_privileges" "disputes_api_tables" {
  database    = postgresql_database.disputes_api.name
  depends_on  = [postgresql_database.disputes_api, postgresql_role.disputes_api]
  object_type = "table"
  owner       = local.master_db_user
  privileges  = local.table_privileges
  role        = postgresql_role.disputes_api.name
  schema      = "public"
}

resource "postgresql_default_privileges" "disputes_api_sequence" {
  database    = postgresql_database.disputes_api.name
  depends_on  = [postgresql_database.disputes_api, postgresql_role.disputes_api]
  object_type = "sequence"
  owner       = local.master_db_user
  privileges  = local.sequence_privileges
  role        = postgresql_role.disputes_api.name
  schema      = "public"
}
