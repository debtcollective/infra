// User for Chatwoot s3 uploads
resource "aws_iam_user" "chatwoot" {
  name = "chatwoot_uploads_${local.environment}"
  path = "/terraform/${local.environment}/chatwoot/"

  tags = {
    Terraform   = true
    Environment = local.environment
  }
}

data "aws_iam_policy_document" "chatwoot" {
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
  name_prefix = "ChatwootPolicy${title(local.environment)}"
  user        = aws_iam_user.chatwoot.name

  policy = data.aws_iam_policy_document.chatwoot.json
}

resource "aws_iam_access_key" "chatwoot" {
  user = aws_iam_user.chatwoot.name
}
