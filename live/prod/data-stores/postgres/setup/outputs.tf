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

# Dispute tools
output "dispute_tools_db_user_ssm_key" {
  value = aws_ssm_parameter.dispute_tools_db_user.name
}

output "dispute_tools_db_pass_ssm_key" {
  value = aws_ssm_parameter.dispute_tools_db_pass.name
}

output "dispute_tools_db_name" {
  value = "dispute_tools_${local.environment}"

}

# Metabase
output "metabase_db_user_ssm_key" {
  value = aws_ssm_parameter.metabase_db_user.name
}

output "metabase_db_pass_ssm_key" {
  value = aws_ssm_parameter.metabase_db_pass.name
}

output "metabase_db_name" {
  value = "metabase_${local.environment}"

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

# Disputes API
output "disputes_api_db_user_ssm_key" {
  value = aws_ssm_parameter.disputes_api_db_user.name
}

output "disputes_api_db_pass_ssm_key" {
  value = aws_ssm_parameter.disputes_api_db_pass.name
}

output "disputes_api_db_name" {
  value = "disputes_api_${local.environment}"

}

# Campaign API
output "campaign_api_db_user_ssm_key" {
  value = aws_ssm_parameter.campaign_api_db_user.name
}

output "campaign_api_db_pass_ssm_key" {
  value = aws_ssm_parameter.campaign_api_db_pass.name
}

output "campaign_api_db_name" {
  value = "campaign_api_${local.environment}"

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
