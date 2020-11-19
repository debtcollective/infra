data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "replication" {
  name = "iam-s3-replication-role-${local.environment}"
  path = "/terraform/${local.environment}/"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]

    resources = [
      local.discourse_uploads_bucket_arn,
      local.dispute_tools_uploads_bucket_arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl"
    ]

    resources = [
      "${local.discourse_uploads_bucket_arn}/*",
      "${local.dispute_tools_uploads_bucket_arn}/*"
    ]
  }

  // This role will have the delete permissions
  // but we won't be using it in replicate buckets
  // Delete actions are not synced with replicas
  statement {
    actions = [
      "s3:ReplicateObject",
    ]

    resources = [
      "${aws_s3_bucket.discourse_uploads_replica.arn}/*",
      "${aws_s3_bucket.dispute_tools_uploads_replica.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "replication" {
  name = "iam-s3-replication-policy-${local.environment}"
  path = "/terraform/${local.environment}/"

  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}
