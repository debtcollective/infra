terraform {
  required_version = ">=0.12.20"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "test-extras-s3"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
}

locals {
  environment = "test"
}

// Replication bucket for Discourse uploads
resource "aws_s3_bucket" "discourse_uploads_replica" {
  bucket = "${local.discourse_uploads_bucket_name}-replica"
  acl    = "private"

  versioning {
    enabled = true
  }
}

// Replication bucket for Dispute tools uploads
resource "aws_s3_bucket" "dispute_tools_uploads_replica" {
  bucket = "${local.dispute_tools_uploads_bucket_name}-replica"
  acl    = "private"

  versioning {
    enabled = true
  }
}
