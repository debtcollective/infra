// S3 buckets and permissions
resource "aws_s3_bucket" "uploads" {
  bucket = local.uploads_bucket_name
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  lifecycle_rule {
    id      = "purge_tombstone"
    enabled = true

    prefix = "tombstone/"

    expiration {
      days                         = 90
      expired_object_delete_marker = false
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Terraform   = true
    Name        = local.uploads_bucket_name
    Environment = local.environment
    Replication = true
  }

  replication_configuration {
    role = local.replication_role_arn

    rules {
      id     = "discourse_uploads_replica_${local.environment}"
      status = "Enabled"

      filter {
      }

      destination {
        bucket        = local.uploads_bucket_replica_arn
        storage_class = "STANDARD"
      }
    }
  }

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket" "backups" {
  bucket = local.backups_bucket_name

  tags = {
    Terraform   = true
    Name        = local.backups_bucket_name
    Environment = local.environment
  }
}
