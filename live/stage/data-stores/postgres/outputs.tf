output "db_address" {
  value = module.postgres.address
}

output "db_port" {
  value = module.postgres.port
}

output "db_name" {
  value = module.postgres.db_name
}
