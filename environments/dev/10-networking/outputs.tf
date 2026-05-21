output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록"
  value       = module.vpc.private_subnet_ids
}
