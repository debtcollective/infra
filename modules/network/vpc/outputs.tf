// VPC ID
output "id" {
  value = "${aws_vpc.default.id}"
}

// EC2 Security group ID
output "ec2_security_group_id" {
  value = "${aws_security_group.ec2.id}"
}

// ELB Security group ID
output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"
}

// RDS Security group ID
output "rds_security_group_id" {
  value = "${aws_security_group.rds.id}"
}

// Redis Security group ID
output "redis_security_group_id" {
  value = "${aws_security_group.redis.id}"
}

// VPC Public subnet IDs
output "public_subnet_ids" {
  value = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}"]
}

// VPC Private subnet IDs
output "private_subnet_ids" {
  value = ["${aws_subnet.private_a.id}", "${aws_subnet.private_b.id}"]
}
