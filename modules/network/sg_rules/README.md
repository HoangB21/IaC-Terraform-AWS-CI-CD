# Security Group Rule Module

This Terraform module creates an **AWS Security Group Rule** and associates it with an existing Security Group.  
It supports both **ingress** (inbound) and **egress** (outbound) rules.

This module is designed to work together with the **security_group** module.

---

## Features
- Adds a rule to an existing Security Group.
- Supports both IPv4 (`cidr_blocks`) and IPv6 (`ipv6_cidr_blocks`).
- Can define ingress or egress rules.
- Allows custom description for each rule.

---

## Usage

```hcl
# Ingress rule: Allow HTTP from anywhere
module "http_rule" {
  source            = "./modules/security_group_rule"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_sg.security_group_id
  description       = "Allow HTTP traffic"
}

# Egress rule: Allow all outbound traffic
module "all_egress" {
  source            = "./modules/security_group_rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = module.web_sg.security_group_id
  description       = "Allow all outbound traffic"
}
````

---

## Inputs

| Name                | Type           | Default | Description                                          |
| ------------------- | -------------- | ------- | ---------------------------------------------------- |
| `type`              | `string`       | n/a     | Type of rule: `ingress` or `egress`.                 |
| `from_port`         | `number`       | n/a     | Start of the port range.                             |
| `to_port`           | `number`       | n/a     | End of the port range.                               |
| `protocol`          | `string`       | n/a     | Protocol (`tcp`, `udp`, `icmp`, `-1` for all).       |
| `cidr_blocks`       | `list(string)` | `[]`    | List of IPv4 CIDR blocks.                            |
| `ipv6_cidr_blocks`  | `list(string)` | `[]`    | List of IPv6 CIDR blocks.                            |
| `security_group_id` | `string`       | n/a     | The ID of the security group to attach this rule to. |
| `description`       | `string`       | `null`  | Description of the rule.                             |

---

## Outputs

This module does not produce any outputs. It only applies the rule to the target security group.

---

## Notes

* A security group can have multiple rules. Simply instantiate this module multiple times with different configurations.
* Make sure that the `security_group_id` is from an existing security group (e.g., created by the `security_group` module).

