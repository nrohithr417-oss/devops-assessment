
variable "aws_region" {
  description = "AWS region for production"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "Production VPC CIDR"
  type        = string
  default     = "10.1.0.0/16"
}

variable "db_password" {
  description = "Production RDS administrator password"
  type        = string
  sensitive   = true
}
