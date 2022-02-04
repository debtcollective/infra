// User for Directus s3 uploads
resource "aws_iam_user" "directus" {
  name = "directus_uploads_${local.environment}"
  path = "/terraform/${local.environment}/directus/"

  tags = {
    Terraform   = true
    Environment = local.environment
  }
}

data "aws_iam_policy_document" "directus" {
  statement {
    sid = "1"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "user_policy" {
  name_prefix = "DirectusPolicy${title(local.environment)}"
  user        = aws_iam_user.directus.name

  policy = data.aws_iam_policy_document.directus.json
}

resource "aws_iam_access_key" "directus" {
  user = aws_iam_user.directus.name
}
