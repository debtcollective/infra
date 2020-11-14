// Generate random username and password
resource "random_string" "discourse_db_user" {
  length  = 16
  special = false
}

resource "random_password" "discourse_db_pass" {
  length           = 24
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "discourse_db_user" {
  name  = "/${local.environment}/services/discourse/db_user"
  type  = "String"
  value = "discourse_${random_string.discourse_db_user.result}"
}

resource "aws_ssm_parameter" "discourse_db_pass" {
  name  = "/${local.environment}/services/discourse/db_pass"
  type  = "SecureString"
  value = random_password.discourse_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "discourse" {
  login               = true
  name                = aws_ssm_parameter.discourse_db_user.value
  password            = aws_ssm_parameter.discourse_db_pass.value
  roles               = [local.master_db_user]
  skip_reassign_owned = true
}

resource "postgresql_database" "discourse" {
  name       = "discourse_${local.environment}"
  owner      = local.master_db_user
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
  encoding   = "UTF8"
}

resource "postgresql_default_privileges" "discourse_tables" {
  database    = postgresql_database.discourse.name
  depends_on  = [postgresql_database.discourse, postgresql_role.discourse]
  object_type = "table"
  owner       = local.master_db_user
  privileges  = local.table_privileges
  role        = postgresql_role.discourse.name
  schema      = "public"
}

resource "postgresql_default_privileges" "discourse_sequence" {
  database    = postgresql_database.discourse.name
  depends_on  = [postgresql_database.discourse, postgresql_role.discourse]
  object_type = "sequence"
  owner       = local.master_db_user
  privileges  = local.sequence_privileges
  role        = postgresql_role.discourse.name
  schema      = "public"
}
