// Generate random username and password
resource "random_string" "wordpress_dev_db_user" {
  length  = 20
  special = false
}

resource "random_password" "wordpress_dev_db_pass" {
  length           = 24
  special          = true
  min_special      = 1
  override_special = "~*^+"
}

// Store both in SSM
resource "aws_ssm_parameter" "wordpress_dev_db_user" {
  name  = "/${local.environment}/services/wordpress_dev/db_user"
  type  = "String"
  value = "wordpress_${random_string.wordpress_dev_db_user.result}"
}

resource "aws_ssm_parameter" "wordpress_dev_db_pass" {
  name  = "/${local.environment}/services/wordpress_dev/db_pass"
  type  = "SecureString"
  value = random_password.wordpress_dev_db_pass.result
}

// Create MySQL user and role
resource "mysql_user" "wordpress_dev" {
  user               = aws_ssm_parameter.wordpress_dev_db_user.value
  host               = "%"
  plaintext_password = aws_ssm_parameter.wordpress_dev_db_pass.value
}

// Create MySQL db
resource "mysql_database" "wordpress_dev" {
  name = "wordpress_dev"
}

resource "mysql_grant" "wordpress_dev" {
  user       = mysql_user.wordpress_dev.user
  host       = mysql_user.wordpress_dev.host
  database   = mysql_database.wordpress_dev.name
  privileges = local.privileges

  depends_on = [mysql_database.wordpress_dev, mysql_user.wordpress_dev]
}
