variable "sg_name" {
  description = "The name of the security group."
  type        = string
}

variable "sg_description" {
  description = "The description of the security group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the security group."
  type        = map(string)
  default     = {}
}

variable "sg_inbound_rules" {
  description = "A list of inbound rules for the security group."
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    description              = optional(string)
  }))
  default = []
}

variable "sg_outbound_rules" {
  description = "A list of outbound rules for the security group."
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    description              = optional(string)
  }))
  default = []
}
