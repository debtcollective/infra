provider "postgresql" {
  host            = "localhost"
  port            = local.master_db_port
  database        = local.master_db_name
  username        = var.db_username
  password        = var.db_password
  sslmode         = "require"
  connect_timeout = 15
}
