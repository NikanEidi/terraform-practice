output "bucket_arn"{
    description = "Real ARN after bucket creation"
    value       = aws_s3_bucket.practice_bucket.arn
}