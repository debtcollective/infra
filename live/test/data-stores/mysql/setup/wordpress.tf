// Generate random username and password
resource "random_string" "wordpress_db_user" {
  length  = 20
  special = false
}

resource "random_password" "wordpress_db_pass" {
  length           = 24
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "wordpress_db_user" {
  name  = "/${local.environment}/services/wordpress/db_user"
  type  = "String"
  value = "wordpress_${random_string.wordpress_db_user.result}"
}

resource "aws_ssm_parameter" "wordpress_db_pass" {
  name  = "/${local.environment}/services/wordpress/db_pass"
  type  = "SecureString"
  value = random_password.wordpress_db_pass.result
}

// Create MySQL user and role
resource "mysql_user" "wordpress" {
  user               = aws_ssm_parameter.wordpress_db_user.value
  host               = "%"
  plaintext_password = aws_ssm_parameter.wordpress_db_pass.value
}

// Create MySQL db
resource "mysql_database" "wordpress" {
  name = "wordpress_${local.environment}"
}

resource "mysql_grant" "wordpress" {
  user       = mysql_user.wordpress.user
  host       = mysql_user.wordpress.host
  database   = mysql_database.wordpress.name
  privileges = local.privileges

  depends_on = [mysql_database.wordpress, mysql_user.wordpress]
}
