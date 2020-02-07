output "slack_topic_arn" {
  description = "Slack SNS Topic ARN"
  value       = module.notify_slack.this_slack_topic_arn
}
