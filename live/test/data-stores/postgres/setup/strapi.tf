// Generate random username and password
resource "random_string" "strapi_db_user" {
  length  = 24
  special = false
}

resource "random_password" "strapi_db_pass" {
  length           = 24
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "strapi_db_user" {
  name  = "/${local.environment}/services/strapi/db_user"
  type  = "String"
  value = "strapi_${random_string.strapi_db_user.result}"
}

resource "aws_ssm_parameter" "strapi_db_pass" {
  name  = "/${local.environment}/services/strapi/db_pass"
  type  = "SecureString"
  value = random_password.strapi_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "strapi" {
  login               = true
  name                = aws_ssm_parameter.strapi_db_user.value
  password            = aws_ssm_parameter.strapi_db_pass.value
  roles               = [local.master_db_user]
  skip_reassign_owned = true
}

resource "postgresql_database" "strapi" {
  name       = "strapi_${local.environment}"
  owner      = local.master_db_user
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
  encoding   = "UTF8"
}

resource "postgresql_default_privileges" "strapi_tables" {
  database    = postgresql_database.strapi.name
  depends_on  = [postgresql_database.strapi, postgresql_role.strapi]
  object_type = "table"
  owner       = local.master_db_user
  privileges  = local.table_privileges
  role        = postgresql_role.strapi.name
  schema      = "public"
}

resource "postgresql_default_privileges" "strapi_sequence" {
  database    = postgresql_database.strapi.name
  depends_on  = [postgresql_database.strapi, postgresql_role.strapi]
  object_type = "sequence"
  owner       = local.master_db_user
  privileges  = local.sequence_privileges
  role        = postgresql_role.strapi.name
  schema      = "public"
}
