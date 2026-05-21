output "cluster_name" {
  description = "EKS 클러스터 이름"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API 서버 엔드포인트"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS 클러스터 CA 인증서"
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "cluster_oidc_issuer" {
  description = "EKS OIDC Issuer URL (IRSA 설정에 사용)"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_role_arn" {
  description = "EKS 노드 IAM Role ARN"
  value       = aws_iam_role.node.arn
}
