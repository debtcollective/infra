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

// Create MySQL user and role
resource "mysql_user" "ghost" {
  user               = aws_ssm_parameter.ghost_db_user.value
  plaintext_password = aws_ssm_parameter.ghost_db_pass.value
}

// Create MySQL db
resource "mysql_database" "ghost" {
  name = "ghost_${local.environment}"
}

resource "mysql_grant" "ghost" {
  user       = mysql_user.ghost.user
  database   = mysql_database.ghost.name
  privileges = local.privileges

  depends_on = [mysql_database.ghost, mysql_user.ghost]
}
