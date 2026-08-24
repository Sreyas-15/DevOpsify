terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend "s3" {
    bucket       = "my-statefile-bucket-devopsify"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

}
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# VPC MODULE

module "VPC" {
  source = "./moduleS/VPC"

  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = local.common_tags
}

# EKS MODULE

module "EKS" {
  source = "./moduleS/EKS"

  project      = var.project
  environment  = var.environment
  cluster_name = var.cluster_name

  subnet_ids      = concat(module.VPC.public_subnet_ids, module.VPC.private_subnet_ids)
  node_subnet_ids = module.VPC.private_subnet_ids

  cluster_version     = var.cluster_version
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_disk_size      = var.node_disk_size
  node_capacity_type  = var.node_capacity_type
  common_tags         = local.common_tags
}
