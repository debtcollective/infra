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
# Wordpress
output "wordpress_db_user_ssm_key" {
  value = aws_ssm_parameter.wordpress_db_user.name
}

output "wordpress_db_pass_ssm_key" {
  value = aws_ssm_parameter.wordpress_db_pass.name
}

output "wordpress_db_name" {
  value = "wordpress_${local.environment}"
}
# Wordpress Dev
output "wordpress_dev_db_user_ssm_key" {
  value = aws_ssm_parameter.wordpress_dev_db_user.name
}

output "wordpress_dev_db__pass_ssm_key" {
  value = aws_ssm_parameter.wordpress_dev_db_pass.name
}

output "wordpress_dev_db_name" {
  value = "wordpress_dev"
}

