
output "be_ami_id" {
  description = "The ID of the AMI created from EC2 instance"
  value       = aws_ami_from_instance.this.id
}

output "launch_template_id" {
  description = "The ID of the Launch Template"
  value       = module.launch_template.launch_template_id
}

output "launch_template_latest_version" {
  description = "The latest version of the Launch Template"
  value       = module.launch_template.launch_template_latest_version
}
