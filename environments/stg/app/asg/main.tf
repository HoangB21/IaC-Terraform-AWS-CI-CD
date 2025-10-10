# Data
data "terraform_remote_state" "subnets" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/subnet/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "launch_template" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/app/launch_template/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/app/alb/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

module "asg" {
  source = "../../../../modules/app/asg"

  name                      = "stg-asg"
  launch_template_id        = data.terraform_remote_state.launch_template.outputs.launch_template_id
  subnet_ids                = data.terraform_remote_state.subnets.outputs.public_subnet_ids
  target_group_arns         = [data.terraform_remote_state.alb.outputs.target_group_arn]
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  target_cpu_utilization    = 50
  health_check_grace_period = 300
  role                      = "backend-ec2"
}
