output "instance_profile_id" {
  value = aws_iam_instance_profile.ecs_profile.id
}

output "instance_role_arn" {
  value = aws_iam_role.ecs_instance_role.arn
}
