// S3 buckets and permissions
resource "aws_s3_bucket" "disputes" {
  bucket = "dispute-tools-${local.environment}"
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Terraform   = true
    Environment = local.environment
  }
}
