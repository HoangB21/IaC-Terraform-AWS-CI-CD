variable "rules" {
  description = "List of SG rules"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    description              = optional(string)
  }))
}

variable "security_group_id" {
  description = "The ID of the security group to apply this rule."
  type        = string
}

variable "type" {
  description = "Type of rule, ingress or egress."
  type        = string
}
