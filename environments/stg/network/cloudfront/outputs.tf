output "fe_storage_bucket_name" {
  description = "The name of the S3 bucket used for storing FE build files."
  value       = aws_s3_bucket.fe_storage.bucket
}

output "cloudfront_distribution_id" {
  description = "The ID of the created CloudFront distribution."
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = module.cloudfront.cloudfront_domain_name
}
