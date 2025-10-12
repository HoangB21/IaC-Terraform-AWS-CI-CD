output "role_name" {
  description = "The name of the created IAM Role."
  value       = module.backend_ec2_role.role_name
}

output "role_arn" {
  description = "The ARN of the IAM Role."
  value       = module.backend_ec2_role.role_arn
}

output "role_id" {
  description = "The ID of the IAM Role."
  value       = module.backend_ec2_role.role_id
}
