// User for Docassemble s3 uploads
resource "aws_iam_user" "docassemble" {
  name = "docassemble_uploads_${local.environment}"
  path = "/terraform/${local.environment}/docassemble/"

  tags = {
    Terraform   = true
    Environment = local.environment
  }
}

data "aws_iam_policy_document" "docassemble" {
  statement {
    sid = "1"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.uploads.arn,
    ]
  }

  statement {
    sid = "2"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.uploads.arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "user_policy" {
  name_prefix = "DocassemblePolicy${title(local.environment)}"
  user        = aws_iam_user.docassemble.name

  policy = data.aws_iam_policy_document.docassemble.json
}

resource "aws_iam_access_key" "docassemble" {
  user = aws_iam_user.docassemble.name
}
