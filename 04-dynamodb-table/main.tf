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

resource "aws_iam_user" "app_user" {
  name = "practice-bucket-user-04"
}

resource "aws_iam_policy" "s3_access" {
  name = "practice-bucket-access-04"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.practice_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_dynamodb_table" "practice_table" {
  name         = "practice-items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.s3_access.arn
}
