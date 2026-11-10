
# Security group for RDS PostgreSQL
resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds-sg"
  description = "Allow PostgreSQL access only from ECS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL access from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

# Private subnet group for RDS
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-hotel-db-subnets"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-hotel-db-subnets"
    Environment = var.environment
  }
}

# PostgreSQL RDS instance
resource "aws_db_instance" "main" {
  identifier        = "${var.environment}-hotel-booking-db"
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "hotel_booking"
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  multi_az                = var.multi_az

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.environment}-hotel-booking-final"

  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.environment}-hotel-booking-db"
    Environment = var.environment
  }
}
