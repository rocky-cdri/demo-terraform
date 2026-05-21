variable "aws_region"      { type = string; default = "ap-northeast-2" }
variable "vpc_cidr"        { type = string }
variable "azs"             { type = list(string) }
variable "public_subnets"  { type = list(string) }
variable "private_subnets" { type = list(string) }
