output "launch_configuration_id" {
  value       = "${aws_launch_configuration.lc.id}"
  description = "Launch Configuration ID"
}

output "autoscaling_group_id" {
  value       = "${aws_autoscaling_group.asg.id}"
  description = "Autoscaling group ID"
}

output "autoscaling_group_name" {
  value       = "${aws_autoscaling_group.asg.name}"
  description = "Autoscaling group name"
}
