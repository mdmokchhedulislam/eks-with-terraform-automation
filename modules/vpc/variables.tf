variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "myproject"
}

variable "environment" {
  description = "Deployment environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Map of public subnets with availability zones"
  type        = map(string)
  default = {
    public_1 = "us-east-1a"
    public_2 = "us-east-1b"
  }
}

variable "private_subnets" {
  description = "Map of private subnets with availability zones"
  type        = map(string)
  default = {
    private_1 = "us-east-1a"
    private_2 = "us-east-1b"
  }
}
