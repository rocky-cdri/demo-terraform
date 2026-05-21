terraform {
  backend "s3" {
    bucket         = "myapp-tfstate-prod"
    key            = "prod/security/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
