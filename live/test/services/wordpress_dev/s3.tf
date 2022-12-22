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

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Terraform   = true
    Name        = local.uploads_bucket_name
    Environment = local.environment
  }
}

data "aws_iam_policy_document" "uploads" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.uploads.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  policy = data.aws_iam_policy_document.uploads.json
}