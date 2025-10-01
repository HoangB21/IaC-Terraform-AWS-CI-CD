terraform {
  backend "s3" {
    bucket         = "hoangtong-tf-state"
    key            = "stg/network/vpc/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
