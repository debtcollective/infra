# Ghost
output "ghost_db_user_ssm_key" {
  value = aws_ssm_parameter.ghost_db_user.name
}

output "ghost_db_pass_ssm_key" {
  value = aws_ssm_parameter.ghost_db_pass.name
}

output "ghost_db_name" {
  value = "ghost_${local.environment}"
}
