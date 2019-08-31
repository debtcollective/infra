output "db_address" {
  value = module.postgres.address
}

output "db_port" {
  value = module.postgres.port
}

output "db_name" {
  value = module.postgres.db_name
}

output "ssm_master_user_key" {
  value = module.postgres.ssm_master_user_key
}

output "ssm_master_pass_key" {
  value = module.postgres.ssm_master_pass_key
}
