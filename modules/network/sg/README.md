# Security Group Module

This Terraform module creates an **AWS Security Group** inside a specified VPC.  
It does not manage inbound or outbound rules directly — rules should be managed separately using the **security_group_rule** module.

---

## Features
- Creates an AWS Security Group in a given VPC.
- Allows custom name, description, and tags.
- Outputs the Security Group ID for use in other modules (e.g., rules, EC2 instances).

---

## Usage

```hcl
module "web_sg" {
  source         = "./modules/security_group"
  sg_name        = "web-sg"
  sg_description = "Security group for web server"
  vpc_id         = module.vpc.vpc_id
  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
````

---

## Inputs

| Name             | Type          | Default                  | Description                                                 |
| ---------------- | ------------- | ------------------------ | ----------------------------------------------------------- |
| `sg_name`        | `string`      | n/a                      | The name of the security group.                             |
| `sg_description` | `string`      | `"Managed by Terraform"` | The description of the security group.                      |
| `vpc_id`         | `string`      | n/a                      | The ID of the VPC where the security group will be created. |
| `tags`           | `map(string)` | `{}`                     | A map of tags to assign to the security group.              |

---

## Outputs

| Name                | Description                           |
| ------------------- | ------------------------------------- |
| `security_group_id` | The ID of the created security group. |

---

## Notes

* This module **only** creates the security group.
* To add ingress/egress rules, use the `security_group_rule` module. Example:

```hcl
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
```