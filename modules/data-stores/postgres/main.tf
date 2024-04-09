locals {
  db_name = "postgres_${var.environment}"
}

// Generate random username and password
resource "random_string" "master_user" {
  length           = 18
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
  name  = "/${var.environment}/data-stores/postgres/master_user"
  type  = "String"
  value = random_string.master_user.result
}

resource "aws_ssm_parameter" "master_pass" {
  name  = "/${var.environment}/data-stores/postgres/master_pass"
  type  = "SecureString"
  value = random_password.master_pass.result
}

resource "aws_db_subnet_group" "pg_sg" {
  name        = "pg-${var.environment}-sg"
  description = "pg-${var.environment} RDS subnet group"
  subnet_ids  = var.subnet_ids
}

// Postgres Parameter group
resource "aws_db_parameter_group" "postgres" {
  name_prefix = "postgres14-"
  family      = "postgres14"

  parameter {
    apply_method = "pending-reboot"
    name         = "pg_stat_statements.track"
    value        = "all"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements"
  }

  # 16kb instead of the default 2kb
  parameter {
    apply_method = "pending-reboot"
    name         = "track_activity_query_size"
    value        = "16393"
  }
}

// Postgres Database
resource "aws_db_instance" "pg" {
  identifier        = "postgres-${var.environment}"
  allocated_storage = var.allocated_storage
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  name              = local.db_name
  username          = aws_ssm_parameter.master_user.value
  password          = aws_ssm_parameter.master_pass.value

  backup_window           = "22:00-23:59"
  maintenance_window      = "sat:20:00-sat:21:00"
  backup_retention_period = "14"

  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = aws_db_subnet_group.pg_sg.name
  parameter_group_name = aws_db_parameter_group.postgres.name

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  multi_az                  = true
  storage_type              = "gp2"
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "pg-${var.environment}-final-${md5(random_string.final_snapshot_identifier.result)}"

  tags = {
    Terraform   = true
    Name        = "postgres-${var.environment}"
    Environment = var.environment
  }
}
