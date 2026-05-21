locals {
  env  = "prod"
  name = "myapp-${local.env}"

  common_tags = {
    Environment = local.env
    ManagedBy   = "terraform"
    Project     = "myapp"
    Layer       = "networking"
  }
}

module "vpc" {
  source = "../../../modules/vpc"

  name            = local.name
  cidr            = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # prod: AZ별 NAT Gateway로 고가용성 확보
  enable_nat_gateway = true
  single_nat_gateway = false

  tags = local.common_tags
}
