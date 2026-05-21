variable "name" {
  description = "리소스 이름 prefix"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "azs" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "NAT Gateway 활성화 여부"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "NAT Gateway 단일 사용 여부 (dev: true, prod: false)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}
