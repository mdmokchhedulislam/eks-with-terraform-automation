variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "Subnets for the EKS control plane"
  type        = list(string)
}

variable "worker_node_subnet_ids" {
  description = "Subnets for worker nodes (private)"
  type        = list(string)
}

variable "bastion_ami_id" {
  type        = string
  default     = "ami-0360c520857e3138f"
}

variable "bastion_key_name" {
  type    = string
  default = "mainaccount"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "project"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "controller_iam_role_name" {
  description = "IAM Role name for EKS cluster controller"
  type        = string
  default     = "project_eks_cluster_role"
}

variable "worker_iam_role_name" {
  description = "IAM Role name for worker nodes"
  type        = string
  default     = "project_eks_node_group_role"
}

variable "node_group_name" {
  description = "EKS Node Group name"
  type        = string
  default     = "worker_node_group"
}

variable "node_group_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}
