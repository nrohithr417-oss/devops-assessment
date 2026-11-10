
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
}

variable "task_memory" {
  description = "Fargate task memory in MB"
  type        = number
}

variable "container_image" {
  description = "Application Docker image"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID for ECS and ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
}
