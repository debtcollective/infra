terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-extras-notify-slack"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "test"
}

module "notify_slack" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-notify-slack.git?ref=tags/v2.10.0"

  sns_topic_name = "notify-slack-${local.environment}-topic"

  slack_webhook_url = var.slack_webhook_url
  slack_channel     = var.slack_channel
  slack_username    = var.slack_username

  lambda_description = "Lambda function which sends notifications to Slack"

  tags = {
    Name      = "cloudwatch-alerts-to-slack-${local.environment}"
    Terraform = true
  }
}
