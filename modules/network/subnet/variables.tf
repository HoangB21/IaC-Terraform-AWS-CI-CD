variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnet (e.g., us-east-1a)."
  type        = string
}

variable "is_public" {
  description = "Set to true to create a public subnet with internet access, false for private subnet."
  type        = bool
}

variable "igw_id" {
  description = "The ID of the Internet Gateway (required if is_public = true)."
  type        = string
  default     = null
}

variable "nat_gw_id" {
  description = "The ID of the NAT Gateway"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
