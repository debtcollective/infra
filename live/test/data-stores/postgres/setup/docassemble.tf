// Generate random username and password
resource "random_string" "docassemble_db_user" {
  length  = 24
  special = false
}

resource "random_password" "docassemble_db_pass" {
  length           = 32
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "docassemble_db_user" {
  name  = "/${local.environment}/services/docassemble/db_user"
  type  = "String"
  value = "docassemble_${random_string.docassemble_db_user.result}"
}

resource "aws_ssm_parameter" "docassemble_db_pass" {
  name  = "/${local.environment}/services/docassemble/db_pass"
  type  = "SecureString"
  value = random_password.docassemble_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "docassemble" {
  login               = true
  name                = aws_ssm_parameter.docassemble_db_user.value
  password            = aws_ssm_parameter.docassemble_db_pass.value
  roles               = [local.master_db_user]
  skip_reassign_owned = true
}

resource "postgresql_database" "docassemble" {
  name       = "docassemble_${local.environment}"
  owner      = local.master_db_user
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
  encoding   = "UTF8"
}

resource "postgresql_default_privileges" "docassemble_tables" {
  database    = postgresql_database.docassemble.name
  depends_on  = [postgresql_database.docassemble, postgresql_role.docassemble]
  object_type = "table"
  owner       = local.master_db_user
  privileges  = local.table_privileges
  role        = postgresql_role.docassemble.name
  schema      = "public"
}

resource "postgresql_default_privileges" "docassemble_sequence" {
  database    = postgresql_database.docassemble.name
  depends_on  = [postgresql_database.docassemble, postgresql_role.docassemble]
  object_type = "sequence"
  owner       = local.master_db_user
  privileges  = local.sequence_privileges
  role        = postgresql_role.docassemble.name
  schema      = "public"
}
