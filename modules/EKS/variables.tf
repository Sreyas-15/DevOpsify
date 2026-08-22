#Use the client name or poc name
variable "project" {
  description = "Project name used in resource naming and tags"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}



variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}


#Mention initial kubernetes version for eks cluster
variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

#Input from the VPC module
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster (both public and private)"
  type        = list(string)
}

#input from vpc, subnets only for nodes here
variable "node_subnet_ids" {
  description = "List of subnet IDs for the node group (typically private subnets only)"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}



variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}


# NODE GROUP CONFIGURATION
variable "node_instance_types" {
  description = "List of EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_disk_size" {
  description = "Disk size in GB for each worker node"
  type        = number
  default     = 20
}

# Set this to ON_DEMAND for the PROD level setups as spot instances might be terminated abruptly
variable "node_capacity_type" {
  description = "Capacity type for the node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}



variable "node_ami_type" {
  description = "AMI type for the node group (AL2_x86_64, AL2_ARM_64, AL2023_x86_64_STANDARD, etc.)"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}


#if the project is poc pls add a poc tag 
variable "common_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
