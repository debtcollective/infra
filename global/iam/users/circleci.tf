resource "aws_iam_user" "circleci" {
  name = "circleci"
  path = "/service_accounts/"

  tags = {
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "circleci_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::tdc-secure/*",
      "arn:aws:s3:::tds-static/*",
      "arn:aws:s3:::powerreport.debtcollective.org/*",
      "arn:aws:s3:::tdc-landing-production/*",
      "arn:aws:s3:::debtcollective.org/*",
      "arn:aws:s3:::strikestudentdebt.org/*"
    ]
  }

  statement {
    actions = [
      "ecs:*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "circleci_policy" {
  name        = "circleci-policy"
  description = "CircleCI user policy"
  policy      = data.aws_iam_policy_document.circleci_policy_document.json
}

resource "aws_iam_user_policy_attachment" "circleci_pa" {
  user       = aws_iam_user.circleci.name
  policy_arn = aws_iam_policy.circleci_policy.arn
}
