output "discourse_uploads_replica_bucket_arn" {
  description = "Discourse replica bucket arn"
  value       = aws_s3_bucket.discourse_uploads_replica.arn
}

output "discourse_uploads_replica_bucket_name" {
  description = "Discourse replica bucket name"
  value       = aws_s3_bucket.discourse_uploads_replica.id
}

output "disputes_uploads_replica_bucket_arn" {
  description = "Disputes replica bucket arn"
  value       = aws_s3_bucket.dispute_tools_uploads_replica.arn
}

output "disputes_uploads_replica_bucket_name" {
  description = "Disputes replica bucket name"
  value       = aws_s3_bucket.dispute_tools_uploads_replica.id
}

output "replication_role_arn" {
  description = "Replication role ARN"
  value       = aws_iam_role.replication.arn
}
