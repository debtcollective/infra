output "fundraising_db_user_ssm_key" {
  value = aws_ssm_parameter.fundraising_db_user.name
}

output "fundraising_db_pass_ssm_key" {
  value = aws_ssm_parameter.fundraising_db_pass.name
}

output "fundraising_db_name" {
  value = "fundraising_${local.environment}"

}

output "disputes_api_db_user_ssm_key" {
  value = aws_ssm_parameter.disputes_api_db_user.name
}

output "disputes_api_db_pass_ssm_key" {
  value = aws_ssm_parameter.disputes_api_db_pass.name
}

output "disputes_api_db_name" {
  value = "disputes_api_${local.environment}"

}

output "mail_for_good_db_user_ssm_key" {
  value = aws_ssm_parameter.mail_for_good_db_user.name
}

output "mail_for_good_db_pass_ssm_key" {
  value = aws_ssm_parameter.mail_for_good_db_pass.name
}

output "mail_for_good_db_name" {
  value = postgresql_database.mail_for_good.name
}
