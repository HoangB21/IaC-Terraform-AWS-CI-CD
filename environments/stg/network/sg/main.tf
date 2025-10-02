data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/vpc/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

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
  sg_name = "stg-public-sg"
}

module "web_server_sg_rule_ssh" {
  source            = "../../../../modules/network/sg_rules"
  security_group_id = module.web_server_sg.security_group_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Custom SSH port"
}

module "web_server_sg_rule_http" {
  source            = "../../../../modules/network/sg_rules"
  security_group_id = module.web_server_sg.security_group_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP"
}

module "web_server_sg_rule_https" {
  source            = "../../../../modules/network/sg_rules"
  security_group_id = module.web_server_sg.security_group_id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTPs"
}

module "web_server_sg_rule_tcp" {
  source            = "../../../../modules/network/sg_rules"
  security_group_id = module.web_server_sg.security_group_id
  type              = "ingress"
  from_port         = 1024
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Custom TCP port"
}

module "web_server_sg_rule_outbound" {
  source            = "../../../../modules/network/sg_rules"
  security_group_id = module.web_server_sg.security_group_id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}


# Security group for MySQL Database
module "mysql_db_sg" {
  source  = "../../../../modules/network/sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_name = "stg-mysql-db-sg"
}

module "mysql_db_sg_rule_inbound" {
  source                   = "../../../../modules/network/sg_rules"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.mysql_db_sg.security_group_id
  source_security_group_id = module.web_server_sg.security_group_id
  description              = "Allow MySQL from app servers"
}
