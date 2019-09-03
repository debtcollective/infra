output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ec2_security_group_id" {
  description = "EC2 Security group ID"
  value       = module.vpc.ec2_security_group_id
}

output "elb_security_group_id" {
  description = "ELB Security group ID"
  value       = module.vpc.elb_security_group_id
}

output "rds_security_group_id" {
  description = "RDS Security group ID"
  value       = module.vpc.rds_security_group_id
}

output "redis_security_group_id" {
  description = "Redis Security group ID"
  value       = module.vpc.redis_security_group_id
}

output "public_subnet_ids" {
  description = "VPC Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "VPC Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ssh_key_pair_name" {
  description = "SSH key pair name"
  value       = aws_key_pair.ssh.key_name
}
