resource "aws_iam_user" "disputes_tools_uploader" {
  name = "disputes_uploader_${local.environment}"
  path = "/terraform/${local.environment}/"

  tags = {
    Terraform   = true
    Environment = local.environment
  }
}

resource "aws_iam_access_key" "disputes_tools_uploader" {
  user = aws_iam_user.disputes_tools_uploader.name
}

data "aws_iam_policy_document" "disputes" {
  statement {
    sid = "1"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.disputes.arn,
      "${aws_s3_bucket.disputes.arn}/*",
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

resource "aws_iam_user_policy" "disputes_tools_uploader_policy" {
  name = "disputes-tools-uploader-policy-${local.environment}"
  user = aws_iam_user.disputes_tools_uploader.name

  policy = data.aws_iam_policy_document.disputes.json
}
