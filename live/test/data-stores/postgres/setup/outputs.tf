# Directus
output "directus_db_user_ssm_key" {
  value = aws_ssm_parameter.directus_db_user.name
}

output "directus_db_pass_ssm_key" {
  value = aws_ssm_parameter.directus_db_pass.name
}
output "directus_db_name" {
  value = "directus_${local.environment}"

}

# Discourse
output "discourse_db_user_ssm_key" {
  value = aws_ssm_parameter.discourse_db_user.name
}

output "discourse_db_pass_ssm_key" {
  value = aws_ssm_parameter.discourse_db_pass.name
}

output "discourse_db_name" {
  value = "discourse_${local.environment}"

}

# Membership
output "membership_db_user_ssm_key" {
  value = aws_ssm_parameter.membership_db_user.name
}

output "membership_db_pass_ssm_key" {
  value = aws_ssm_parameter.membership_db_pass.name
}

output "membership_db_name" {
  value = postgresql_database.membership.name

}

# Chatwoot
output "chatwoot_db_user_ssm_key" {
  value = aws_ssm_parameter.chatwoot_db_user.name
}

output "chatwoot_db_pass_ssm_key" {
  value = aws_ssm_parameter.chatwoot_db_pass.name
}

output "chatwoot_db_name" {
  value = postgresql_database.chatwoot.name
}

# Docassemble
output "docassemble_db_user_ssm_key" {
  value = aws_ssm_parameter.docassemble_db_user.name
}

output "docassemble_db_pass_ssm_key" {
  value = aws_ssm_parameter.docassemble_db_pass.name
}

output "docassemble_db_name" {
  value = postgresql_database.docassemble.name
}
