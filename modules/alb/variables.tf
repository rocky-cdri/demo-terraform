variable "name" {
  description = "리소스 이름 prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "ALB를 배치할 퍼블릭 서브넷 ID 목록"
  type        = list(string)
}

variable "security_group_ids" {
  description = "ALB에 적용할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "certificate_arn" {
  description = "HTTPS 인증서 ARN (비어 있으면 HTTP only)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}
