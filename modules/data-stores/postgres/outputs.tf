output "db_name" {
  value = local.db_name
}

output "address" {
  value = aws_db_instance.pg.address
}

output "port" {
  value = aws_db_instance.pg.port
}
