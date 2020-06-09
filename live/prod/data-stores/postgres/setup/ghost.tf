// Generate random username and password
resource "random_string" "ghost_db_user" {
  length  = 20
  special = false
}

resource "random_password" "ghost_db_pass" {
  length           = 24
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "ghost_db_user" {
  name  = "/${local.environment}/services/ghost/db_user"
  type  = "String"
  value = "ghost_${random_string.ghost_db_user.result}"
}

resource "aws_ssm_parameter" "ghost_db_pass" {
  name  = "/${local.environment}/services/ghost/db_pass"
  type  = "SecureString"
  value = random_password.ghost_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "ghost" {
  login               = true
  name                = aws_ssm_parameter.ghost_db_user.value
  password            = aws_ssm_parameter.ghost_db_pass.value
  roles               = [local.master_db_user]
  skip_reassign_owned = true
}

resource "postgresql_database" "ghost" {
  name       = "ghost_${local.environment}"
  owner      = local.master_db_user
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
  encoding   = "UTF8"
}

resource "postgresql_default_privileges" "ghost_tables" {
  database    = postgresql_database.ghost.name
  depends_on  = [postgresql_database.ghost, postgresql_role.ghost]
  object_type = "table"
  owner       = local.master_db_user
  privileges  = local.table_privileges
  role        = postgresql_role.ghost.name
  schema      = "public"
}

resource "postgresql_default_privileges" "ghost_sequence" {
  database    = postgresql_database.ghost.name
  depends_on  = [postgresql_database.ghost, postgresql_role.ghost]
  object_type = "sequence"
  owner       = local.master_db_user
  privileges  = local.sequence_privileges
  role        = postgresql_role.ghost.name
  schema      = "public"
}
