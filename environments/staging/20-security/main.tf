locals {
  env  = "staging"
  name = "myapp-${local.env}"
  common_tags = { Environment = local.env, ManagedBy = "terraform", Project = "myapp", Layer = "security" }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config  = { bucket = "myapp-tfstate-staging", key = "staging/networking/terraform.tfstate", region = "ap-northeast-2" }
}

module "security_groups" {
  source = "../../../modules/security-groups"
  name   = local.name
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
  tags   = local.common_tags
}
