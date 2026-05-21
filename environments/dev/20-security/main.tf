locals {
  env  = "dev"
  name = "myapp-${local.env}"

  common_tags = {
    Environment = local.env
    ManagedBy   = "terraform"
    Project     = "myapp"
    Layer       = "security"
  }
}

# ──────────────────────────────────────────
# 10-networking 레이어 output 참조
# ──────────────────────────────────────────
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "myapp-tfstate-dev"
    key    = "dev/networking/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

module "security_groups" {
  source = "../../../modules/security-groups"

  name   = local.name
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id

  tags = local.common_tags
}
