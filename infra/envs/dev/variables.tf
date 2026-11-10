
variable "aws_region" {
  description = "AWS region for development environment"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR range for development VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_password" {
  description = "Development RDS administrator password"
  type        = string
  sensitive   = true
}
