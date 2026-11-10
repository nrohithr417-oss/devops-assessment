
output "vpc_id" {
  description = "Production VPC ID"
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "Production application load balancer DNS"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Production ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "rds_endpoint" {
  description = "Private production PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}