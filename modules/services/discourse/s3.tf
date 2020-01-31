// S3 buckets and permissions
resource "aws_s3_bucket" "uploads" {
  bucket = "community-uploads-${var.environment}"
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

  tags = {
    Terraform   = true
    Name        = "community-uploads-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "backups" {
  bucket = "community-backups-${var.environment}"

  tags = {
    Terraform   = true
    Name        = "community-backups-${var.environment}"
    Environment = var.environment
  }
}
