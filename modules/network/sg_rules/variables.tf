variable "type" {
  description = "Type of rule, ingress or egress."
  type        = string
}

variable "from_port" {
  description = "Start of port range for the rule."
  type        = number
}

variable "to_port" {
  description = "End of port range for the rule."
  type        = number
}

variable "protocol" {
  description = "Protocol (e.g., tcp, udp, icmp, -1 for all)."
  type        = string
}

variable "cidr_blocks" {
  description = "List of IPv4 CIDR blocks."
  type        = list(string)
  default     = []
}

variable "ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks."
  type        = list(string)
  default     = []
}

variable "security_group_id" {
  description = "The ID of the security group to apply this rule."
  type        = string
}

variable "source_security_group_id" {
  type        = string
  default     = null
  description = "Security Group ID to allow traffic from (used instead of cidr_blocks)."
}

variable "description" {
  description = "Description of the rule."
  type        = string
  default     = null
}
