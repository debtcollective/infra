// Generate random username and password
resource "random_string" "campaign_api_db_user" {
  length  = 16
  special = false
}

resource "random_password" "campaign_api_db_pass" {
  length           = 20
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "campaign_api_db_user" {
  name  = "/${local.environment}/services/campaign_api/db_user"
  type  = "String"
  value = "campaign_api_${random_string.campaign_api_db_user.result}"
}

resource "aws_ssm_parameter" "campaign_api_db_pass" {
  name  = "/${local.environment}/services/campaign_api/db_pass"
  type  = "SecureString"
  value = random_password.campaign_api_db_pass.result
}

// Create postgres role and db
resource "postgresql_role" "campaign_api" {
  login               = true
  name                = aws_ssm_parameter.campaign_api_db_user.value
  password            = aws_ssm_parameter.campaign_api_db_pass.value
  roles               = [local.master_db_user]
  skip_reassign_owned = true
}

resource "postgresql_database" "campaign_api" {
  name       = "campaign_api_${local.environment}"
  owner      = local.master_db_user
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
  encoding   = "UTF8"
}

resource "postgresql_default_privileges" "campaign_api_tables" {
  database    = postgresql_database.campaign_api.name
  depends_on  = [postgresql_database.campaign_api, postgresql_role.campaign_api]
  object_type = "table"
  owner       = local.master_db_user
  privileges  = local.table_privileges
  role        = postgresql_role.campaign_api.name
  schema      = "public"
}

resource "postgresql_default_privileges" "campaign_api_sequence" {
  database    = postgresql_database.campaign_api.name
  depends_on  = [postgresql_database.campaign_api, postgresql_role.campaign_api]
  object_type = "sequence"
  owner       = local.master_db_user
  privileges  = local.sequence_privileges
  role        = postgresql_role.campaign_api.name
  schema      = "public"
}
