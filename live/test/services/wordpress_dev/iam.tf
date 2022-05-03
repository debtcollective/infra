// User for wordpress s3 uploads
resource "aws_iam_user" "wordpress_dev" {
  name = "wordpress_uploads_${local.environment}"
  path = "/terraform/${local.environment}/wordpress_dev/"

  tags = {
    Terraform   = true
    Environment = local.environment
  }
}

data "aws_iam_policy_document" "wordpress_dev" {
  statement {
    sid = "1"

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
    ]

    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*",
    ]
  }

  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "s3:HeadBucket",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user_policy" "user_policy" {
  name_prefix = "WordpressPolicy${title(local.environment)}"
  user        = aws_iam_user.wordpress_dev.name

  policy = data.aws_iam_policy_document.wordpress_dev.json
}

resource "aws_iam_access_key" "wordpress_dev" {
  user = aws_iam_user.wordpress_dev.name
}
