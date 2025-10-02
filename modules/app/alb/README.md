# Application Load Balancer (ALB) Module

This Terraform module creates an **AWS Application Load Balancer (ALB)**, a **Target Group**, and a **Listener**.  
It is designed for **reusability** and **basic usage**, making it easy to integrate into different projects.

---

## 🚀 Features
- Create an **Application Load Balancer (ALB)** with configurable subnets and security groups.
- Create a **Target Group** with health checks.
- Create a **Listener** that forwards requests to the target group.
- Support for custom tags.

---

## 📂 Resources
This module manages the following resources:
- `aws_lb` – The Application Load Balancer
- `aws_lb_target_group` – Target group for routing traffic
- `aws_lb_listener` – Listener to accept incoming requests and forward them to the target group

---

## 🔧 Usage Example

```hcl
module "alb" {
  source = "./modules/alb"

  name                       = "my-alb"
  internal                   = false
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false

  target_group_name     = "my-target-group"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  vpc_id                = aws_vpc.main.id

  health_check_protocol = "HTTP"
  health_check_path     = "/"

  listener_port     = 80
  listener_protocol = "HTTP"

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
````

---

## 📥 Inputs

| Name                         | Type           | Default  | Description                                        |
| ---------------------------- | -------------- | -------- | -------------------------------------------------- |
| `name`                       | `string`       | n/a      | Name of the ALB.                                   |
| `internal`                   | `bool`         | `false`  | Whether the load balancer is internal.             |
| `security_groups`            | `list(string)` | n/a      | List of security group IDs to attach to the ALB.   |
| `subnets`                    | `list(string)` | n/a      | List of subnet IDs to attach to the ALB.           |
| `enable_deletion_protection` | `bool`         | `false`  | Enable deletion protection for the ALB.            |
| `target_group_name`          | `string`       | n/a      | Name of the Target Group.                          |
| `target_group_port`          | `number`       | n/a      | Port for the Target Group.                         |
| `target_group_protocol`      | `string`       | n/a      | Protocol for the Target Group (e.g., HTTP, HTTPS). |
| `vpc_id`                     | `string`       | n/a      | VPC ID where the Target Group will be created.     |
| `health_check_protocol`      | `string`       | `"HTTP"` | Protocol for health checks.                        |
| `health_check_path`          | `string`       | `"/"`    | Path for health checks.                            |
| `listener_port`              | `number`       | n/a      | Port on which the ALB listener will listen.        |
| `listener_protocol`          | `string`       | n/a      | Protocol for the ALB listener (e.g., HTTP, HTTPS). |
| `tags`                       | `map(string)`  | `{}`     | Tags to apply to resources.                        |

---

## 📤 Outputs

| Name               | Description              |
| ------------------ | ------------------------ |
| `alb_arn`          | ARN of the ALB.          |
| `alb_dns_name`     | DNS name of the ALB.     |
| `target_group_arn` | ARN of the Target Group. |
| `listener_arn`     | ARN of the Listener.     |

---

## 📝 Notes

* The ALB requires **at least two subnets** in different Availability Zones.
* Ensure the **security group** allows inbound traffic on the listener port (e.g., 80 or 443).
* For HTTPS, you must add an **SSL certificate ARN** to the listener.
