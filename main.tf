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
    bucket = "liorm-jfrog-tfstate"
    key    = "data/terraform.tfstate"
    region = "us-east-1"

  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc-network" {
    source = "./resources/vpc-network/"
}

module "eks-cluster" {
    source = "./resources/eks-cluster"

    # cluster_name = var.cluster_name
    # cluster_endpoint = var.cluster_endpoint
    # cluster_ca = var.cluster_ca_certificate
}
