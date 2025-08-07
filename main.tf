terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }

    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = "~>1.14"
    # }
  }
  backend "s3" {
    bucket = "liorm-portfolio-tfstate"
    key    = "data/terraform.tfstate"
    region = "us-east-1"

  }
}

provider "aws" {
  region = var.REGION
}

module "vpc-network" {
    source = "./resources/vpc-network/"
    cluster_name = var.cluster_name
    vpc_name = var.vpc_name
    cluster_version = var.cluster_version
    private_subnet_cidrs = var.private_subnet_cidrs
    public_subnet_cidrs = var.public_subnet_cidrs
    vpc_cidr_block = var.vpc_cidr_block
    # private-us-east-1a-id = var.private-us-east-1a-id
    # private-us-east-1b-id = var.private-us-east-1b-id
    # public-us-east-1a-id = var.public-us-east-1a-id
    # public-us-east-1b-id = var.public-us-east-1b-id


}

module "eks-cluster" {
    source = "./resources/eks-cluster"

    cluster_name = var.cluster_name
    # cluster_endpoint = var.cluster_endpoint
    # cluster_ca = var.cluster_ca_certificate
    capacity_type = var.capacity_type
    EbsCredSecret = var.EbsCredSecret
    REGION = var.REGION
    ACCOUNT = var.ACCOUNT
    instance_types = var.instance_types
    node_name = var.node_name
    node_group_name = var.node_group_name
    max_size = var.max_size
    cluster_version = var.cluster_version
    CredSecret = var.CredSecret
    desired_size = var.desired_size
        # Pass subnet IDs from the vpc-network module's outputs
    private_subnet_ids = module.vpc-network.private_subnet_ids
    public_subnet_ids = module.vpc-network.public_subnet_ids

}
