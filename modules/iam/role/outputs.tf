
output "role_name" {
  description = "The name of the created IAM Role."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "The ARN of the IAM Role."
  value       = aws_iam_role.this.arn
}

output "role_id" {
  description = "The ID of the IAM Role."
  value       = aws_iam_role.this.id
}
