output "db_name" {
  value = local.db_name
}

output "address" {
  value = aws_db_instance.pg.address
}

output "port" {
  value = aws_db_instance.pg.port
}

output "ssm_master_user_key" {
  value = aws_ssm_parameter.master_user.name
}

output "ssm_master_pass_key" {
  value = aws_ssm_parameter.master_pass.name
}
