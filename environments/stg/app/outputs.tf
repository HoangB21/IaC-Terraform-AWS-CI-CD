output "alb_id" {
  description = "The ID of the ALB."
  value       = module.alb.alb_id
}

output "alb_arn" {
  description = "The ARN of the ALB."
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB."
  value       = module.alb.alb_zone_id
}

output "target_group_arn" {
  description = "The ARN of the target group."
  value       = module.alb.target_group_arn
}

output "listener_arn" {
  description = "The ARN of the ALB listener."
  value       = module.alb.listener_arn
}
