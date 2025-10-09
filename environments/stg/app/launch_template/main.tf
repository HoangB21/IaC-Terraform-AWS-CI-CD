# Data
data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/sg/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/app/ec2/terraform.tfstate"
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

resource "aws_ami_from_instance" "this" {
  name                    = "web-server-ami"
  source_instance_id      = data.terraform_remote_state.ec2.outputs.main_be_instance_id
  description             = "An AMI for BE web server"
  snapshot_without_reboot = false
  tags                    = local.common_tags
}

module "launch_template" {
  source             = "../../../../modules/app/launch_template"
  ami_id             = aws_ami_from_instance.this.id
  instance_type      = "t3.micro"
  name               = "backend-template"
  key_name           = "hoang-key-pair"
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.web_server_sg_id]

  tags = local.common_tags
}
