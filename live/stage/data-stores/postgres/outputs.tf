// VPC ID
output "db_address" {
  value = module.postgres.address
}

// EC2 Security group ID
output "db_port" {
  value = module.postgres.port
}
