variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role for EKS"
  type        = string
}

variable "vpc_subnets" {
  description = "List of VPC subnet IDs"
  type        = list(string)
}

variable "node_group_name" {
  description = "The name of the node group"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for the node group"
  type        = list(string)
}

variable "node_disk_size" {
  description = "Disk size for the node group instances"
  type        = number
}

variable "principal_arn" {
  description = "The ARN of the principal"
  type        = string
}

variable "kubernetes_groups" {
  description = "Kubernetes groups"
  type        = list(string)
}

variable "access_policy_arn" {
  description = "The ARN of the access policy"
  type        = string
}

# Security group variables

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed"
  type        = string
}

#new

variable "create_iam_role" {
  description = "Whether to create a new IAM role for the EKS cluster"
  type        = bool
  default     = false
}

variable "create_node_iam_role" {
  description = "Whether to create a new IAM role for the EKS node group"
  type        = bool
  default     = false
}

variable "policy_arns" {
  description = "List of IAM policy ARNs for cluster and node group"
  type        = list(string)
}

#
variable "cluster_iam_role_name" {
  description = "Name of the existing IAM role for the EKS cluster (if not creating a new one)"
  type        = string
  default     = "eks-cluster-role"
}

variable "node_group_iam_role_name" {
  description = "Name of the existing IAM role for the EKS node group (if not creating a new one)"
  type        = string
  default     = "eks-node-group-role"
}