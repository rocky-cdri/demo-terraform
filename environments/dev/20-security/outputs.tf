output "alb_sg_id" {
  description = "ALB 보안 그룹 ID"
  value       = module.security_groups.alb_sg_id
}

output "eks_nodes_sg_id" {
  description = "EKS 노드 보안 그룹 ID"
  value       = module.security_groups.eks_nodes_sg_id
}

output "rds_sg_id" {
  description = "RDS 보안 그룹 ID"
  value       = module.security_groups.rds_sg_id
}
