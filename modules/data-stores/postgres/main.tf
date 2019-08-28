terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "stage-postgres"
    }
  }
}

resource "aws_db_subnet_group" "pg_sg" {
  name        = "pg-${var.environment}-sg"
  description = "pg-${var.environment} RDS subnet group"
  subnet_ids  = local.subnet_ids
}

// Postgres Database
resource "aws_db_instance" "pg" {
  identifier        = "postgres-${var.environment}"
  allocated_storage = "20"
  engine            = "postgres"
  engine_version    = "11.4"
  instance_class    = "db.t2.micro"
  name              = "postgres-${var.environment}"
  username          = var.db_username
  password          = var.db_password

  backup_window           = "22:00-23:59"
  maintenance_window      = "sat:20:00-sat:21:00"
  backup_retention_period = "14"

  vpc_security_group_ids = local.vpc_security_group_ids

  db_subnet_group_name = aws_db_subnet_group.pg_sg.name
  parameter_group_name = "default.postgres11"

  multi_az                  = true
  storage_type              = "gp2"
  skip_final_snapshot       = false
  final_snapshot_identifier = "postgres-${var.environment}"

  tags = {
    Terraform   = true
    Name        = "postgres-${var.environment}"
    Environment = var.environment
  }
}
