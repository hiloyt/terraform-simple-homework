###################
# ECR
###################

output "repository_registry_id" {
  description = "Registry ID"
  value       = module.ecr.repository_registry_id
}

output "repository_url" {
  description = "Repo URL"
  value       = module.ecr.repository_url
}

###################
# RDS
###################

output "db_instance_address" {
  description = "DB URL"
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "DB Port"
  value       = module.rds.db_instance_port
}

###################
# EKS
###################

output "cluster_name" {
  description = "Cluster name"
  value       = module.eks.cluster_name
}