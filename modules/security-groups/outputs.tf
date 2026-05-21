output "alb_sg_id" {
  description = "ALB 보안 그룹 ID"
  value       = aws_security_group.alb.id
}

output "eks_nodes_sg_id" {
  description = "EKS 노드 보안 그룹 ID"
  value       = aws_security_group.eks_nodes.id
}

output "rds_sg_id" {
  description = "RDS 보안 그룹 ID"
  value       = aws_security_group.rds.id
}
