resource "aws_s3_bucket" "practice_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_user" "app_user" {
  name = var.user_name
}

resource "aws_iam_policy" "s3_access" {
  name = "${var.user_name}-access"

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

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.s3_access.arn
}