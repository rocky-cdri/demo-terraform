variable "name" {
  description = "클러스터 이름 prefix"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes 버전"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "EKS 노드 서브넷 ID 목록"
  type        = list(string)
}

variable "node_security_group_id" {
  description = "노드에 적용할 보안 그룹 ID"
  type        = string
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

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}
