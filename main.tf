
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.6.0"
    }
  }
  backend "s3" {
    bucket  = "my-linked-tf-test-bucket33"
    key     = "data/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }



}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

}

module "eks" {
  source                 = "./modules/eks"
  public_subnet_id       = module.vpc.public_subnet_ids[0]
  vpc_id                 = module.vpc.vpc_id
  vpc_subnet_ids         = module.vpc.private_subnet_ids
  worker_node_subnet_ids = module.vpc.private_subnet_ids
}

module "addons" {
  source = "./modules/eks-addons"
  cluster_name = "project"
  vpc_id = module.vpc.vpc_id
  vpc_cni_version = "v1.20.2-eksbuild.1"
  kube_proxy_version = "v1.33.3-eksbuild.6"
  coredns_version = "v1.12.4-eksbuild.1"
  ebs_csi_version = "v1.50.1"
  

}