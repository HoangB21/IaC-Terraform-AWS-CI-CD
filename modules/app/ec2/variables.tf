variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script to configure the instance at launch"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {}
}
