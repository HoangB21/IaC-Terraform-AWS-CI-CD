data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/network/vpc/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

locals {
  common_tags = {
    Created_by  = "Tong Viet Hoang"
    Project     = "STP-2025"
    Environment = "Staging"
  }
  azs                  = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnet_count  = 2
  private_subnet_count = 2
}

module "public_subnet" {
  source            = "../../../../modules/network/subnet"
  count             = local.public_subnet_count
  subnet_name       = "stg-public-subnet-${format("%02d", count.index + 1)}"
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = local.azs[count.index]
  is_public         = true
  igw_id            = data.terraform_remote_state.vpc.outputs.igw_id
  tags              = local.common_tags
}

module "private_subnet" {
  source            = "../../../../modules/network/subnet"
  count             = local.private_subnet_count
  subnet_name       = "stg-private-subnet-${format("%02d", count.index + 1)}"
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = "10.${count.index + 1}.0.0/24"
  availability_zone = local.azs[count.index]
  is_public         = false
  igw_id            = data.terraform_remote_state.vpc.outputs.igw_id
  tags              = local.common_tags
}
