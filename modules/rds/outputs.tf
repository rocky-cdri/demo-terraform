output "db_instance_id" {
  description = "RDS 인스턴스 ID"
  value       = aws_db_instance.this.id
}

output "db_instance_endpoint" {
  description = "RDS 연결 엔드포인트"
  value       = aws_db_instance.this.endpoint
  sensitive   = true
}

output "db_instance_arn" {
  description = "RDS 인스턴스 ARN"
  value       = aws_db_instance.this.arn
}

output "db_subnet_group_name" {
  description = "DB 서브넷 그룹 이름"
  value       = aws_db_subnet_group.this.name
}
