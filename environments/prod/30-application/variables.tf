variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "kubernetes_version" {
  description = "Kubernetes 버전"
  type        = string
  default     = "1.29"
}

variable "db_password" {
  description = "RDS 마스터 비밀번호"
  type        = string
  sensitive   = true
}

variable "node_groups" {
  description = "EKS 노드 그룹 설정"
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
  }))
}

variable "certificate_arn" {
  description = "ACM 인증서 ARN"
  type        = string
  default     = ""
}
