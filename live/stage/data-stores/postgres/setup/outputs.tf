output "fundraising_db_user" {
  value = random_string.fundraising_db_user.result
}

output "fundraising_db_pass" {
  value = random_password.fundraising_db_pass.result
}

output "fundraising_db_name" {
  value = "fundraising_${local.environment}"
}
