output "main_be_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_main_backend.instance_id
}

output "main_be_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2_main_backend.private_ip
}

output "main_be_public_ip" {
  description = "The public IP address of the EC2 instance (if applicable)"
  value       = module.ec2_main_backend.public_ip
}

output "ec2_ssm_instance_profile_name" {
  description = "The name of the IAM instance profile for SSM"
  value       = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}
