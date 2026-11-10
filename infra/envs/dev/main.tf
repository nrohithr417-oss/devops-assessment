
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Skip AWS credential checks for assessment-only planning.
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# Network infrastructure
module "network" {
  source = "../../modules/network"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  enable_nat_gateway = true
}

# ECS and Application Load Balancer
module "ecs" {
  source = "../../modules/ecs"

  environment = var.environment
  aws_region  = var.aws_region

  vpc_id = module.network.vpc_id

  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  task_cpu    = 256
  task_memory = 512

  container_image = "public.ecr.aws/docker/library/nginx:latest"

  log_retention_days = 7
  desired_count      = 1
}

# PostgreSQL RDS database
module "rds" {
  source = "../../modules/rds"

  environment = var.environment

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_subnet_ids

  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_instance_class = "db.t3.micro"
  allocated_storage = 20

  db_username = "hoteladmin"
  db_password = var.db_password

  backup_retention_period = 1
  deletion_protection     = false
  multi_az                = false
  skip_final_snapshot     = true
}
