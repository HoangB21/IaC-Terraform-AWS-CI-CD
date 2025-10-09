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

module "ec2_main_backend" {
  source = "../../../../modules/app/ec2"

  name               = "stg-be-ec2"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = "t3.micro"
  subnet_id          = data.terraform_remote_state.subnets.outputs.public_subnet_ids[0]
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.web_server_sg_id]
  key_name           = "hoang-key-pair"

  user_data = <<-EOT
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1
    set -x
    apt update
    apt install unzip

    # Change port for ssh
    echo "Port 8080" | sudo tee -a /etc/ssh/sshd_config
    sudo systemctl enable ssh
    sudo systemctl start ssh

    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # Install mysql client
    apt install mysql-client -y

    # Install Node.js and npm using nvm
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs

    # Install PM2 to run Node.js app
    npm install pm2 -g
    cd /home/ubuntu

    # Clone the app repository
    git clone https://github.com/HoangB21/Social-App-BE
    cd Social-App-BE
    npm ci

    # Create .env file
    echo "DB_HOST=stg-mysql.cpk0wk0uaymd.ap-southeast-2.rds.amazonaws.com" >> .env
    echo "DB_USER=admin" >> .env
    echo "DB_PASSWORD=RootAdmin" >> .env
    echo "DB_NAME=social_app" >> .env
    echo "DB_PORT=3306" >> .env
    echo "AWS_REGION=ap-southeast-2" >> .env
    echo "S3_BUCKET_NAME=socialapp-hoangtong" >> .env
    echo "ALLOWED_ORIGINS=*" >> .env

    export HOME=/home/ubuntu
    pm2 start index.js --name "social-app"
    pm2 startup systemd
    env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
    pm2 save
    chown -R ubuntu:ubuntu /home/ubuntu/

  EOT
  tags      = local.common_tags
}
