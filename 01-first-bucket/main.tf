# Tells Terraform which provider to use (AWS) and which version range is okay.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # any 5.x version, not 6.0
    }
  }
}

# Configures the AWS provider itself — which region to create things in.
provider "aws" {
  region = "us-east-1"
}

# The actual thing being created: one S3 bucket.
# "practice_bucket" is just a local name I use inside this Terraform project.
# "bucket = ..." is the real bucket name on AWS — has to be globally unique.
resource "aws_s3_bucket" "practice_bucket" {
  bucket = "nikan-terraform-practice-01"
}
