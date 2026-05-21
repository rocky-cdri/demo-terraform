locals {
  env  = "dev"
  name = "myapp-${local.env}"

  common_tags = {
    Environment = local.env
    ManagedBy   = "terraform"
    Project     = "myapp"
    Layer       = "application"
  }
}

# ──────────────────────────────────────────
# 하위 레이어 output 참조
# ──────────────────────────────────────────
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "myapp-tfstate-dev"
    key    = "dev/networking/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "myapp-tfstate-dev"
    key    = "dev/security/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# ──────────────────────────────────────────
# EKS
# ──────────────────────────────────────────
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

# ──────────────────────────────────────────
# RDS
# ──────────────────────────────────────────
module "rds" {
  source = "../../../modules/rds"

  name               = local.name
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  database_name      = "myappdb"
  username           = "postgres"
  password           = var.db_password
  subnet_ids         = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.security.outputs.rds_sg_id]

  # dev: 비용 절감을 위해 Multi-AZ 비활성화
  multi_az                = false
  backup_retention_period = 1
  deletion_protection     = false

  tags = local.common_tags
}

# ──────────────────────────────────────────
# ALB
# ──────────────────────────────────────────
module "alb" {
  source = "../../../modules/alb"

  name               = local.name
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.networking.outputs.public_subnet_ids
  security_group_ids = [data.terraform_remote_state.security.outputs.alb_sg_id]

  tags = local.common_tags
}
