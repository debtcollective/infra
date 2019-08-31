provider "postgresql" {
  host            = "localhost"
  port            = local.master_db_port
  database        = local.master_db_name
  username        = local.master_db_user
  password        = local.master_db_pass
  sslmode         = "require"
  connect_timeout = 15
}
