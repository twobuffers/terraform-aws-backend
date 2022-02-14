output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The S3 bucket created to store the Terraform state."
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.terraform_locks.arn
  description = "The DynamoDB table created for make possible to lock operations on the state."
}
