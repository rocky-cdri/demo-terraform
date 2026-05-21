locals {
  env  = "prod"
  name = "myapp-${local.env}"

  common_tags = {
    Environment = local.env
    ManagedBy   = "terraform"
    Project     = "myapp"
    Layer       = "application"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "myapp-tfstate-prod"
    key    = "prod/networking/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "myapp-tfstate-prod"
    key    = "prod/security/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

module "eks" {
  source = "../../../modules/eks"

  name                   = local.name
  kubernetes_version     = var.kubernetes_version
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids             = data.terraform_remote_state.networking.outputs.private_subnet_ids
  node_security_group_id = data.terraform_remote_state.security.outputs.eks_nodes_sg_id
  node_groups            = var.node_groups

  tags = local.common_tags
}

module "rds" {
  source = "../../../modules/rds"

  name               = local.name
  instance_class     = "db.r6g.large"
  allocated_storage  = 100
  database_name      = "myappdb"
  username           = "postgres"
  password           = var.db_password
  subnet_ids         = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.security.outputs.rds_sg_id]

  # prod: Multi-AZ 활성화, 삭제 방지 활성화
  multi_az                = true
  backup_retention_period = 7
  deletion_protection     = true

  tags = local.common_tags
}

module "alb" {
  source = "../../../modules/alb"

  name               = local.name
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.networking.outputs.public_subnet_ids
  security_group_ids = [data.terraform_remote_state.security.outputs.alb_sg_id]
  certificate_arn    = var.certificate_arn

  tags = local.common_tags
}
