# VPC Module (with Internet Gateway)

This Terraform module creates:
- An AWS Virtual Private Cloud (VPC).
- An Internet Gateway (IGW) attached to the VPC.

It does not create subnets, route tables, or NAT gateways. You can extend this module or combine it with other modules to build a complete network setup.

---

## Features
- Creates an AWS VPC with a specified CIDR block.
- Creates and attaches an Internet Gateway.
- Supports enabling/disabling DNS support and DNS hostnames.
- Allows custom tagging.

---

## Usage

```
module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = "my-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
```
## Inputs
| Name                   | Type          | Default | Description                                            |
| ---------------------- | ------------- | ------- | ------------------------------------------------------ |
| `vpc_name`             | `string`      | n/a     | The name to assign to the VPC.                         |
| `cidr_block`           | `string`      | n/a     | The CIDR block for the VPC (e.g., `10.0.0.0/16`).      |
| `enable_dns_support`   | `bool`        | `true`  | Enable DNS support in the VPC.                         |
| `enable_dns_hostnames` | `bool`        | `true`  | Enable DNS hostnames in the VPC.                       |
| `tags`                 | `map(string)` | `{}`    | A map of additional tags to assign to the VPC and IGW. |


## Outputs
| Name             | Description                     |
| ---------------- | ------------------------------- |
| `vpc_id`         | The ID of the VPC.              |
| `vpc_arn`        | The ARN of the VPC.             |
| `vpc_cidr_block` | The CIDR block of the VPC.      |
| `igw_id`         | The ID of the Internet Gateway. |

## Notes
* This module does not configure subnets, route tables, or NAT gateways. You must define those separately to enable routing for private/public subnets.

* The IGW is only useful when you associate it with a route table that directs traffic to the internet.