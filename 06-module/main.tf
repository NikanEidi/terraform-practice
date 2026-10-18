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

module "app" {
  source = "./modules/s3-with-access"

  bucket_name = "nikan-terraform-practice-06"
  user_name   = "practice-bucket-user-06"
}