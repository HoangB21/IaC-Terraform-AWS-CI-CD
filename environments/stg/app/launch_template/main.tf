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
  source               = "../../../../modules/app/launch_template"
  ami_id               = aws_ami_from_instance.this.id
  instance_type        = "t3.micro"
  name                 = "backend-template"
  key_name             = "hoang-key-pair"
  user_data            = <<-EOT
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1
    echo "Running user data script at $(date). Created by Tong Viet Hoang"
    echo "Starting EC2 instance bootstrap process..."
    chown -R ubuntu:ubuntu /home/ubuntu/
    sudo su - ubuntu -c "cd /home/ubuntu/Social-App-BE && git tag -l | xargs git tag -d && git pull origin main --tags && git checkout $(git describe --tags --abbrev=0) && pm2 restart all"

  EOT
  security_group_ids   = [data.terraform_remote_state.security_groups.outputs.web_server_sg_id]
  iam_instance_profile = data.terraform_remote_state.ec2.outputs.ec2_ssm_instance_profile_name

  tags = local.common_tags
}
