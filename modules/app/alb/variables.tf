# ALB
variable "name" {
  description = "The name of the ALB."
  type        = string
}

variable "internal" {
  description = "If true, the ALB will be internal. Otherwise, internet-facing."
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security group IDs for the ALB."
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs for the ALB."
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to assign to resources."
  type        = map(string)
  default     = {}
}

# Target Group
variable "target_group_name" {
  description = "Name of the target group."
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group."
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the target group (HTTP/HTTPS)."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the target group is created."
  type        = string
}

variable "health_check_protocol" {
  description = "Protocol for health check."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path for health check requests."
  type        = string
  default     = "/"
}

# Listener
variable "listener_port" {
  description = "Listener port (e.g. 80 or 443)."
  type        = number
}

variable "listener_protocol" {
  description = "Listener protocol (HTTP or HTTPS)."
  type        = string
}
