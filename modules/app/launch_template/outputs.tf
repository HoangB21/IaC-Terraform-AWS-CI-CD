output "launch_template_id" {
  description = "The ID of the Launch Template"
  value       = aws_launch_template.this.id
}

output "launch_template_latest_version" {
  description = "The latest version of the Launch Template"
  value       = aws_launch_template.this.latest_version
}
