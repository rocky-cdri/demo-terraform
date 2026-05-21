output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "NAT Gateway ID 목록"
  value       = aws_nat_gateway.this[*].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}
