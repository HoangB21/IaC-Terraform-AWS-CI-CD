module "vpc" {
  source = "../../../../modules/network/vpc"

  cidr_block           = "10.0.0.0/16"
  vpc_name             = "stg-main-vpc"
  enable_dns_hostnames = true
  enable_dns_support   = true
}
