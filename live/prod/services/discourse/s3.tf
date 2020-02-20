// S3 buckets and permissions
resource "aws_s3_bucket" "uploads" {
  bucket = local.uploads_bucket_name
  acl    = "private"

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

    // copy all directories except for the assets one
    rules {
      id       = "discourse_original_${local.environment}"
      status   = "Enabled"
      priority = 0

      filter {
        prefix = "original/"
      }

      destination {
        bucket        = local.uploads_bucket_replica_arn
        storage_class = "STANDARD"
      }
    }

    rules {
      id       = "discourse_optimized_${local.environment}"
      status   = "Enabled"
      priority = 1

      filter {
        prefix = "optimized/"
      }

      destination {
        bucket        = local.uploads_bucket_replica_arn
        storage_class = "STANDARD"
      }
    }

    rules {
      id       = "discourse_tombstone_${local.environment}"
      status   = "Enabled"
      priority = 2

      filter {
        prefix = "tombstone/"
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

data "aws_iam_policy_document" "uploads" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.uploads.arn}/assets/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  // Enable access from Cloudfront Distribution
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.uploads.arn
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.uploads.iam_arn]
    }
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.uploads.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.uploads.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  policy = data.aws_iam_policy_document.uploads.json
}

resource "aws_s3_bucket" "backups" {
  bucket = local.backups_bucket_name

  tags = {
    Terraform   = true
    Name        = local.backups_bucket_name
    Environment = local.environment
  }
}
