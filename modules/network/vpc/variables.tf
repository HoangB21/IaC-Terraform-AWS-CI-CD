variable "vpc_name" {
  description = "The name to assign to the VPC."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)."
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of additional tags to assign to the VPC and IGW."
  type        = map(string)
  default     = {}
}
