// S3 Bucket and permissions
resource "aws_s3_bucket" "disputes" {
  bucket = "dispute-tools-uploads-${var.environment}"
  acl    = "private"

  tags {
    Terraform   = true
    Name        = "Staging bucket"
    Environment = var.environment
  }
}

resource "aws_iam_user" "disputes_uploader" {
  name = "disputes-uploader-${var.environment}"
}

resource "aws_iam_access_key" "disputes_uploader" {
  user = aws_iam_user.disputes_uploader.name
}

data "template_file" "disputes_uploader_policy_document" {
  template = file("${path.module}/bucket-policy.json")

  vars {
    resource_arn = aws_s3_bucket.disputes.arn
  }
}

resource "aws_iam_user_policy" "disputes_uploader_policy" {
  name = "disputes-uploader-policy-${var.environment}"
  user = aws_iam_user.disputes_uploader.name

  policy = data.template_file.disputes_uploader_policy_document.rendered
}
