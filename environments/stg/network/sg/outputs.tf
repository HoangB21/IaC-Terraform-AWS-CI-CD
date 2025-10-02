output "web_server_sg_id" {
  description = "The ID of created Web Server Security Group"
  value       = module.web_server_sg.security_group_id
}

output "mysql_db_sg_id" {
  description = "The ID of created MySQL DB Security Group"
  value       = module.mysql_db_sg.security_group_id
}
