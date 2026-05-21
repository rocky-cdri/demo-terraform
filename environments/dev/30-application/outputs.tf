output "eks_cluster_name" {
  description = "EKS 클러스터 이름"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API 엔드포인트"
  value       = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  description = "RDS 엔드포인트"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = module.alb.alb_dns_name
}
