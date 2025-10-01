# Subnet Module

This Terraform module creates an AWS Subnet inside a given VPC.  
It supports both **public** and **private** subnets using the `is_public` variable.

- **Public subnet**: Automatically associates a route table with a default route (`0.0.0.0/0`) pointing to an Internet Gateway (IGW).  
- **Private subnet**: Associates a route table without an Internet route (no direct internet access).  

This module does **not** create a NAT Gateway. If you want internet access for private subnets, you need to create a NAT Gateway separately and extend this module.

---

## Features
- Creates a subnet with a custom CIDR block and availability zone.
- Differentiates between public and private subnets using the `is_public` flag.
- Creates and associates a dedicated route table per subnet.
- Supports custom tagging.

---

## Usage

```hcl
# Public subnet
module "public_subnet" {
  source            = "./modules/subnet"
  subnet_name       = "app"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  is_public         = true
  igw_id            = module.vpc.igw_id
  tags = {
    Environment = "dev"
  }
}

# Private subnet
module "private_subnet" {
  source            = "./modules/subnet"
  subnet_name       = "db"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  is_public         = false
  tags = {
    Environment = "dev"
  }
}
````

---

## Inputs

| Name                | Type          | Default | Description                                                      |
| ------------------- | ------------- | ------- | ---------------------------------------------------------------- |
| `subnet_name`       | `string`      | n/a     | The name of the subnet.                                          |
| `vpc_id`            | `string`      | n/a     | The ID of the VPC where the subnet will be created.              |
| `cidr_block`        | `string`      | n/a     | The CIDR block for the subnet.                                   |
| `availability_zone` | `string`      | n/a     | The availability zone for the subnet (e.g., `us-east-1a`).       |
| `is_public`         | `bool`        | n/a     | Set to `true` for a public subnet, `false` for a private subnet. |
| `igw_id`            | `string`      | `null`  | The Internet Gateway ID (required if `is_public = true`).        |
| `tags`              | `map(string)` | `{}`    | A map of tags to assign to resources.                            |

---

## Outputs

| Name             | Description                                           |
| ---------------- | ----------------------------------------------------- |
| `subnet_id`      | The ID of the created subnet.                         |
| `route_table_id` | The ID of the route table associated with the subnet. |

---

## Notes

* Public subnets require an Internet Gateway (`igw_id` must be provided).
* Private subnets created by this module do not have internet access by default. To enable internet access, you need to add a NAT Gateway and update the route table accordingly.
* Each subnet gets its own dedicated route table created and associated automatically.
