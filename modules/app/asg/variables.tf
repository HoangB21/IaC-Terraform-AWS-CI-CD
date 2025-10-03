variable "name" {
  description = "Prefix for the Auto Scaling Group name"
  type        = string
}

variable "launch_template_id" {
  description = "ID of the Launch Template"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "target_group_arns" {
  description = "List of Target Group ARNs to associate with the ASG"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "Type of health check (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time in seconds after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "target_cpu_utilization" {
  description = "Target average CPU utilization for scaling"
  type        = number
  default     = 50
}
