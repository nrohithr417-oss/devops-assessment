
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for RDS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group allowed to connect to RDS"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16"
}

variable "db_instance_class" {
  description = "RDS instance size"
  type        = string
}

variable "allocated_storage" {
  description = "Database storage in GB"
  type        = number
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Automated backup retention in days"
  type        = number
}

variable "deletion_protection" {
  description = "Protect database from accidental deletion"
  type        = bool
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting database"
  type        = bool
}
