terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0" # any 5.x version, not 6.0
        }
    }
}

provider "aws"{
    region = "us-east-1"
}

resource "aws_s3_bucket" "practice_bucket" {
  bucket = var.bucket_name
}