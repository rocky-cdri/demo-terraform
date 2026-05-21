# ─────────────────────────────────────────────
# ALB Security Group
# ─────────────────────────────────────────────
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-alb-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

# ─────────────────────────────────────────────
# EKS Node Security Group
# ─────────────────────────────────────────────
resource "aws_security_group" "eks_nodes" {
  name        = "${var.name}-eks-nodes-sg"
  description = "EKS Node Security Group"
  vpc_id      = var.vpc_id

  # ALB에서 들어오는 트래픽 허용
  ingress {
    description     = "Traffic from ALB"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # 노드 간 통신 허용
  ingress {
    description = "Node to Node communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-eks-nodes-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

# ─────────────────────────────────────────────
# RDS Security Group
# ─────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  # EKS 노드에서만 DB 접근 허용
  ingress {
    description     = "PostgreSQL from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-rds-sg" })

  lifecycle {
    create_before_destroy = true
  }
}
