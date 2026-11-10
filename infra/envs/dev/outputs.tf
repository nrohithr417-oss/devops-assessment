
output "vpc_id" {
  description = "Development VPC ID"
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "Public application load balancer DNS"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "rds_endpoint" {
  description = "Private PostgreSQL RDS endpoint"
  value       = module.rds.db_endpoint
}
