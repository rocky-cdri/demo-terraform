variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "azs" {
  description = "가용 영역 목록"
  type        = list(string)
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
}

variable "private_subnets" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
}
