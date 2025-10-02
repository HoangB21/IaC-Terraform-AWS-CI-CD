output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2_instance.private_ip
}

output "public_ip" {
  description = "The public IP address of the EC2 instance (if applicable)"
  value       = module.ec2_instance.public_ip
}

output "ami_id" {
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
