# Data
data "terraform_remote_state" "security_groups" {
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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-*-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
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

module "ec2_instance" {
  source             = "../../../../modules/app/ec2"
  name               = "stg-main-ec2"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = "t3.micro"
  subnet_id          = data.terraform_remote_state.subnets.outputs.public_subnet_ids[0]
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.web_server_sg_id]
  key_name           = "hoang-key-pair"

  user_data = <<-EOT
    #!/bin/bash
    apt update
    apt install -y apache2
    systemctl start apache2
    systemctl enable apache2

    apt install mysql-client -y

    echo "Port 8080" | sudo tee -a /etc/ssh/sshd_config
    sudo systemctl enable ssh
    sudo systemctl start ssh
  EOT

  tags = local.common_tags
}

resource "aws_ami_from_instance" "this" {
  name                    = "web-server-ami"
  source_instance_id      = module.ec2_instance.instance_id
  snapshot_without_reboot = false
  tags                    = local.common_tags
}

module "launch_template" {
  source             = "../../../../modules/app/launch_template"
  ami_id             = aws_ami_from_instance.this.id
  instance_type      = "t3.micro"
  name               = "web-server-template"
  key_name           = "hoang-key-pair"
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.web_server_sg_id]

  user_data = <<-EOT
    #!/bin/bash
    apt update
    apt install -y apache2
    systemctl start apache2
    systemctl enable apache2

    apt install mysql-client -y

    echo "Port 8080" | sudo tee -a /etc/ssh/sshd_config
    sudo systemctl enable ssh
    sudo systemctl start ssh
  EOT

  tags = local.common_tags
}
