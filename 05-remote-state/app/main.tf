terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # This project's state lives in the bootstrap bucket, not on this
  # laptop. use_lockfile enables S3-native locking (no separate
  # DynamoDB table needed — a newer Terraform feature, 1.10+).
  backend "s3" {
    bucket       = "nikan-terraform-practice-state-2026"
    key          = "05-remote-state/app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "practice_bucket" {
  bucket = "nikan-terraform-practice-05"
}

output "bucket_arn" {
  description = "Real ARN after bucket creation"
  value       = aws_s3_bucket.practice_bucket.arn
}
