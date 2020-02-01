// User for Discourse s3 uploads
resource "aws_iam_user" "discourse" {
  name = "discourse_uploads"
  path = "/terraform/${var.environment}/"

  tags = {
    Terraform = true
  }
}

data "aws_iam_policy_document" "discourse" {
  statement {
    sid = "1"

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:CreateBucket",
    ]

    resources = [
      aws_s3_bucket.uploads.arn,
      aws_s3_bucket.backups.arn,
      "${aws_s3_bucket.uploads.arn}/*",
      "${aws_s3_bucket.backups.arn}/*",
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
  name_prefix = "DiscoursePolicy${title(var.environment)}"
  user        = aws_iam_user.discourse.name

  policy = data.aws_iam_policy_document.discourse.json
}

resource "aws_iam_access_key" "discourse" {
  user = aws_iam_user.discourse.name
}
