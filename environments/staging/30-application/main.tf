locals {
  env  = "staging"
  name = "myapp-${local.env}"
  common_tags = { Environment = local.env, ManagedBy = "terraform", Project = "myapp", Layer = "application" }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config  = { bucket = "myapp-tfstate-staging", key = "staging/networking/terraform.tfstate", region = "ap-northeast-2" }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config  = { bucket = "myapp-tfstate-staging", key = "staging/security/terraform.tfstate", region = "ap-northeast-2" }
}

module "eks" {
  source                 = "../../../modules/eks"
  name                   = local.name
  kubernetes_version     = var.kubernetes_version
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids             = data.terraform_remote_state.networking.outputs.private_subnet_ids
  node_security_group_id = data.terraform_remote_state.security.outputs.eks_nodes_sg_id
  node_groups            = var.node_groups
  tags                   = local.common_tags
}

module "rds" {
  source                  = "../../../modules/rds"
  name                    = local.name
  instance_class          = "db.t3.small"
  allocated_storage       = 50
  database_name           = "myappdb"
  username                = "postgres"
  password                = var.db_password
  subnet_ids              = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_ids      = [data.terraform_remote_state.security.outputs.rds_sg_id]
  multi_az                = false
  backup_retention_period = 3
  deletion_protection     = false
  tags                    = local.common_tags
}

module "alb" {
  source             = "../../../modules/alb"
  name               = local.name
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.networking.outputs.public_subnet_ids
  security_group_ids = [data.terraform_remote_state.security.outputs.alb_sg_id]
  tags               = local.common_tags
}
