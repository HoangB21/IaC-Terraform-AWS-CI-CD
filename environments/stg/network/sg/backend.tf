terraform {
  backend "s3" {
    bucket       = "hoangtong-tf-state"
    key          = "stg/network/sg/terraform.tfstate"
    region       = "ap-southeast-2"
    use_lockfile = true # instead of dynamoDB
  }
}
