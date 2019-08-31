output "fundraising_db_user_ssm_key" {
  value = aws_ssm_parameter.fundraising_db_user.name
}

output "fundraising_db_pass_ssm_key" {
  value = aws_ssm_parameter.fundraising_db_pass.name
}

output "fundraising_db_name" {
  value = "fundraising_${local.environment}"
}
