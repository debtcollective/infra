provider "postgresql" {
  connect_timeout = 15
  database        = local.master_db_name
  host            = "localhost"
  password        = local.master_db_pass
  port            = local.master_db_port
  sslmode         = "require"
  superuser       = false
  username        = local.master_db_user
}
