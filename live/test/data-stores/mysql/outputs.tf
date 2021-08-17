output "db_address" {
  value = module.mysql.address
}

output "db_port" {
  value = module.mysql.port
}

output "db_name" {
  value = module.mysql.db_name
}

output "ssm_master_user_key" {
  value = module.mysql.ssm_master_user_key
}

output "ssm_master_pass_key" {
  value = module.mysql.ssm_master_pass_key
}
