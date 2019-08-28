// VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

// EC2 Security group ID
output "ec2_security_group_id" {
  value = module.vpc.ec2_security_group_id
}

// ELB Security group ID
output "elb_security_group_id" {
  value = module.vpc.elb_security_group_id
}

// RDS Security group ID
output "rds_security_group_id" {
  value = module.vpc.rds_security_group_id
}

// Redis Security group ID
output "redis_security_group_id" {
  value = module.vpc.redis_security_group_id
}

// VPC Public subnet IDs
output "public_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

// VPC Private subnet IDs
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
