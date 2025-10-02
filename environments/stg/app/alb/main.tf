# Data
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/vpc/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "alb_sg" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/sg/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "subnets" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/subnet/terraform.tfstate"
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

module "alb" {
  source = "../../../../modules/app/alb"

  # ALB
  name            = "stg-alb"
  internal        = false
  security_groups = [data.terraform_remote_state.alb_sg.outputs.alb_sg_id]
  subnets         = data.terraform_remote_state.subnets.outputs.public_subnet_ids

  # Target group
  target_group_name     = "stg-tg"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id

  # Listener
  listener_port     = 80
  listener_protocol = "HTTP"

  tags = {
    Created_by  = "Tong Viet Hoang"
    Environment = "Staging"
    Project     = "STP-2025"
  }
}
