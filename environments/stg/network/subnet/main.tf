module "vpc" {
  source = "../vpc"
}

locals {
  common_tags = {
    Created_by  = "Tong Viet Hoang"
    Project     = "STP-2025"
    Environment = "Staging"
  }
  azs = ["ap-southeast-2a", "ap-southeast-2b"]
}

module "public_subnet" {
  source            = "../../../../modules/network/subnet"
  count             = 2
  subnet_name       = "stg-public-subnet-${format("%02d", count.index + 1)}"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = local.azs[count.index]
  is_public         = true
  igw_id            = module.vpc.igw_id
  tags              = local.common_tags
}

module "private_subnet" {
  source            = "../../../../modules/network/subnet"
  count             = 2
  subnet_name       = "stg-private-subnet-${format("%02d", count.index + 1)}"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = local.azs[count.index]
  is_public         = true
  igw_id            = module.vpc.igw_id
  tags              = local.common_tags
}
