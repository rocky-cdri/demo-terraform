terraform {
  backend "s3" {
    bucket         = "myapp-tfstate-dev"
    key            = "dev/application/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
