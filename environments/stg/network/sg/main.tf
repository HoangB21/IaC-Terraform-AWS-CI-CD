# Data
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/vpc/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

# Local variables
locals {
  common_tags = {
    Created_by  = "Tong Viet Hoang"
    Project     = "STP-2025"
    Environment = "Staging"
  }
}


# Security group for EC2 Web Server
module "web_server_sg" {
  source  = "../../../../modules/network/sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_name = "stg-web-server-sg"
  sg_inbound_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Custom SSH port"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPs"
    }
  ]
  sg_outbound_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  sg_description = "Security group for Web Server"
  tags           = local.common_tags
}


# Security group for MySQL Database
module "mysql_db_sg" {
  source  = "../../../../modules/network/sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_name = "stg-mysql-db-sg"
  sg_inbound_rules = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.web_server_sg.security_group_id
      description              = "Allow MySQL from app servers"
    }
  ]
  sg_outbound_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  tags = local.common_tags
}

# Security group for Application Load Balancer
module "alb_sg" {
  source  = "../../../../modules/network/sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_name = "stg-alb-sg"
  sg_inbound_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
    }
  ]
  sg_outbound_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  tags = local.common_tags
}
