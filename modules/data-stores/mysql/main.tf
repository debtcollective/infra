locals {
  db_name = "mysql_${var.environment}"
}

// Generate random username and password
resource "random_string" "master_user" {
  length           = 24
  special          = false
  override_special = "~*^+"
}

resource "random_password" "master_pass" {
  length           = 24
  special          = true
  override_special = "~*^+"
}

resource "random_string" "final_snapshot_identifier" {
  length  = 8
  special = false
  upper   = false
}

// Store both in SSM
resource "aws_ssm_parameter" "master_user" {
  name  = "/${var.environment}/data-stores/mysql/master_user"
  type  = "String"
  value = random_string.master_user.result
}

resource "aws_ssm_parameter" "master_pass" {
  name  = "/${var.environment}/data-stores/mysql/master_pass"
  type  = "SecureString"
  value = random_password.master_pass.result
}

resource "aws_db_subnet_group" "mysql_sg" {
  name        = "mysql-${var.environment}-sg"
  description = "mysql-${var.environment} RDS subnet group"
  subnet_ids  = var.subnet_ids
}

// MySQL Parameter group
resource "aws_db_parameter_group" "mysql" {
  name_prefix = "mysql8-"
  family      = "mysql8.0.36"
}

// MySQL Database
resource "aws_db_instance" "mysql" {
  identifier        = "mysql-${var.environment}"
  allocated_storage = var.allocated_storage
  engine            = "mysql"
  engine_version    = "8.0.36"
  instance_class    = var.instance_class
  name              = local.db_name
  username          = aws_ssm_parameter.master_user.value
  password          = aws_ssm_parameter.master_pass.value

  backup_window           = "22:00-23:59"
  maintenance_window      = "sat:20:00-sat:21:00"
  backup_retention_period = "14"

  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = aws_db_subnet_group.mysql_sg.name
  parameter_group_name = aws_db_parameter_group.mysql.name

  multi_az                  = true
  storage_type              = "gp2"
  skip_final_snapshot       = false
  final_snapshot_identifier = "mysql-${var.environment}-final-${md5(random_string.final_snapshot_identifier.result)}"

  tags = {
    Terraform   = true
    Name        = "mysql-${var.environment}"
    Environment = var.environment
  }
}
