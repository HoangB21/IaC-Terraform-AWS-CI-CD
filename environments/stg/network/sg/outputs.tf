output "web_server_sg_id" {
  description = "The ID of created Web Server Security Group"
  value       = module.web_server_sg.security_group_id
}

output "mysql_db_sg_id" {
  description = "The ID of created MySQL DB Security Group"
  value       = module.mysql_db_sg.security_group_id
}

output "alb_sg_id" {
  description = "The ID of created Application Load Balancer Security Group"
  value       = module.alb_sg.security_group_id
}
