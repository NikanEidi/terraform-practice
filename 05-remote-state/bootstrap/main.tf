terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# This bucket is permanent infrastructure, not a disposable practice
# resource — it holds the real state for the "app" project next door.
resource "aws_s3_bucket" "tf_state" {
  bucket = "nikan-terraform-practice-state-2026"
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "state_bucket_name" {
  description = "Name of the bucket the app/ project points its backend at"
  value       = aws_s3_bucket.tf_state.bucket
}
