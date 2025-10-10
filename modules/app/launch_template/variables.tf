variable "name" {
  description = "Prefix for the Launch Template name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "The name or ARN of the IAM instance profile to associate with the instance."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script to configure the instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
