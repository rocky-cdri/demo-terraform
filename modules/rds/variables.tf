variable "name" {
  description = "리소스 이름 prefix"
  type        = string
}

variable "engine" {
  description = "DB 엔진"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "DB 엔진 버전"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "DB 인스턴스 클래스"
  type        = string
}

variable "allocated_storage" {
  description = "할당 스토리지 (GB)"
  type        = number
}

variable "database_name" {
  description = "초기 데이터베이스 이름"
  type        = string
}

variable "username" {
  description = "마스터 사용자 이름"
  type        = string
}

variable "password" {
  description = "마스터 비밀번호"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "DB 서브넷 그룹에 사용할 서브넷 ID 목록"
  type        = list(string)
}

variable "security_group_ids" {
  description = "적용할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "multi_az" {
  description = "Multi-AZ 배포 여부"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "백업 보존 기간 (일)"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "삭제 방지 활성화 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}
