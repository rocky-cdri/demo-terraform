locals {
  env  = "staging"
  name = "myapp-${local.env}"
  common_tags = {
    Environment = local.env
    ManagedBy   = "terraform"
    Project     = "myapp"
    Layer       = "networking"
  }
}

module "vpc" {
  source          = "../../../modules/vpc"
  name            = local.name
  cidr            = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = local.common_tags
}
