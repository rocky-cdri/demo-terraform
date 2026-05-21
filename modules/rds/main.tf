# ─────────────────────────────────────────────
# DB Subnet Group
# ─────────────────────────────────────────────
resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-db-subnet-group"
  description = "DB subnet group for ${var.name}"
  subnet_ids  = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.name}-db-subnet-group" })
}

# ─────────────────────────────────────────────
# RDS Parameter Group
# ─────────────────────────────────────────────
resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-pg15"
  family      = "postgres15"
  description = "Custom parameter group for ${var.name}"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = var.tags
}

# ─────────────────────────────────────────────
# RDS Instance
# ─────────────────────────────────────────────
resource "aws_db_instance" "this" {
  identifier = "${var.name}-db"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 3
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.database_name
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  parameter_group_name   = aws_db_parameter_group.this.name

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  deletion_protection = var.deletion_protection
  skip_final_snapshot = !var.deletion_protection
  final_snapshot_identifier = var.deletion_protection ? "${var.name}-final-snapshot" : null

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  tags = merge(var.tags, { Name = "${var.name}-db" })
}
