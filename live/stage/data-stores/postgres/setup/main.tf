provider "postgresql" {
  host            = "localhost"
  port            = local.db_port
  database        = local.db_name
  username        = var.db_username
  password        = var.db_password
  sslmode         = "require"
  connect_timeout = 15
}
