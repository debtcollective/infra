// S3 buckets and permissions
resource "aws_s3_bucket" "disputes" {
  bucket = "dispute-tools-${local.environment}"
  acl    = "private"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Terraform   = true
    Environment = local.environment
    Replication = true
  }

  replication_configuration {
    role = local.replication_role_arn

    rules {
      id     = "dispute_tools_uploads_replica_${local.environment}"
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
