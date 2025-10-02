# Database Module

Terraform module for creating an **AWS RDS Database Instance** with a subnet group.
This module is designed to be **simple, safe, and reusable** for dev/test or production usage.

---

## Features

* Creates an **RDS DB Instance** in a specified VPC subnet group.
* Allows custom **engine, version, instance class, and storage**.
* Supports **VPC security groups**.
* Safe defaults for dev/test:

  * `skip_final_snapshot = true` (no snapshot on deletion).
  * `publicly_accessible = false` (not exposed to the public internet).

---

## Usage

```hcl
module "db" {
  source = "./modules/db"

  name                   = "mydb"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "appdb"
  username               = "admin"
  password               = "changeme123"
  subnet_ids             = ["subnet-12345678", "subnet-abcdef12"]
  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  # Optional overrides
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

---

## Inputs

| Name                     | Type           | Description                                                              | Required |
| ------------------------ | -------------- | ------------------------------------------------------------------------ | -------- |
| `name`                   | `string`       | Identifier for the DB instance. Used for subnet group and instance name. | ✅        |
| `allocated_storage`      | `number`       | The allocated storage in gigabytes.                                      | ✅        |
| `engine`                 | `string`       | The database engine to use (e.g., `mysql`, `postgres`).                  | ✅        |
| `engine_version`         | `string`       | The engine version (e.g., `8.0`, `14.5`).                                | ✅        |
| `instance_class`         | `string`       | The instance type of the RDS instance (e.g., `db.t3.micro`).             | ✅        |
| `db_name`                | `string`       | The name of the initial database to create.                              | ✅        |
| `username`               | `string`       | The master username for the database.                                    | ✅        |
| `password`               | `string`       | The master password for the database (sensitive).                        | ✅        |
| `subnet_ids`             | `list(string)` | List of subnet IDs for the DB subnet group.                              | ✅        |
| `vpc_security_group_ids` | `list(string)` | List of VPC security groups to associate.                                | ✅        |
| `skip_final_snapshot`    | `bool`         | Whether to skip final snapshot before deletion (default: `true`).        | ✅        |
| `publicly_accessible`    | `bool`         | Whether the DB instance is publicly accessible (default: `false`).       | ✅        |
| `tags`                   | `map(string)`  | Key-value tags to apply to resources.                                    | ❌        |

---

## Outputs

| Name                     | Description                                  |
| ------------------------ | -------------------------------------------- |
| `db_instance_endpoint`   | The connection endpoint of the RDS instance. |
| `db_instance_identifier` | The RDS instance identifier.                 |

---

## Notes

* For production usage, consider setting:

  * `skip_final_snapshot = false` to retain a final snapshot.
  * `publicly_accessible = true` only if you need public DB access.
* Ensure `password` meets AWS complexity requirements.
