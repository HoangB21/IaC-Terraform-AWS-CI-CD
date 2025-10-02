data "terraform_remote_state" "private_subnets" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/subnet/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "db_security_group" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/sg/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

module "db" {
  source                 = "../../../modules/db"
  name                   = "stg-mysql"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mysqlDB" # begin with alphabet, only number and alphabet
  username               = "admin"
  password               = "RootAdmin" # meets AWS complexity requirements
  subnet_ids             = data.terraform_remote_state.private_subnets.outputs.private_subnet_ids
  vpc_security_group_ids = [data.terraform_remote_state.db_security_group.outputs.mysql_db_sg_id]

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Created_by  = "Tong Viet Hoang"
    Environment = "Staging"
    Project     = "STP-2025"
  }
}
