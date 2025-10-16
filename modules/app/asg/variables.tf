variable "name" {
  description = "Prefix for the Auto Scaling Group name"
  type        = string
}

variable "launch_template_id" {
  description = "ID of the Launch Template"
  type        = string
}

variable "launch_template_version" {
  description = "Version of the Launch Template"
  type        = string
  default     = "$Latest"
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

variable "enable_instance_refresh" {
  description = "Enable instance refresh for the ASG"
  type        = bool
  default     = false
}

variable "instance_refresh_strategy" {
  description = "Strategy for instance refresh (RollingUpdate or None)"
  type        = string
  default     = "Rolling"
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum healthy percentage for instance refresh"
  type        = number
  default     = 90
}

variable "instance_refresh_instance_warmup" {
  description = "Instance warmup time for instance refresh"
  type        = number
  default     = 300
}

variable "instance_refresh_triggers" {
  description = "Triggers for instance refresh"
  type        = list(string)
  default     = ["launch_template"]
}

variable "role" {
  description = "Role tag for the instances in the ASG"
  type        = string
  default     = "ec2-instance"
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
