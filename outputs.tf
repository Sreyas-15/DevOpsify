# VPC

output "vpc_id" {
  description = "VPC ID"
  value       = module.VPC.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.VPC.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.VPC.private_subnet_ids
}


# EKS

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.EKS.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.EKS.cluster_endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.EKS.cluster_arn
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = module.EKS.node_group_id
}
