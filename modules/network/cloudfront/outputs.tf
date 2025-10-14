output "cloudfront_distribution_id" {
  description = "The ID of the created CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_status" {
  description = "Current status of the CloudFront distribution (e.g., InProgress, Deployed)."
  value       = aws_cloudfront_distribution.this.status
}
