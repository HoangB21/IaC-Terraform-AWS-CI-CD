variable "name" {
  description = "The name of the IAM Role."
  type        = string
}

variable "description" {
  description = "A description for the IAM Role."
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = <<EOT
The trust policy (in JSON format) that grants an entity permission to assume the role.
Example:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
  type        = string
}

variable "policy_arns" {
  description = "A list of IAM managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the IAM Role."
  type        = map(string)
  default     = {}
}

variable "inline_policy" {
  description = "Optional inline policy JSON string attached directly to the IAM Role."
  type        = string
  default     = null
}
