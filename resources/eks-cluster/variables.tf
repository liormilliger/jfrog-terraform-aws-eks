module "subnet_ids" {
  source = "../vpc-network/"
}

####< CLUSTER VARS >####

variable "cluster_name" {
  default = "liorm-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
}

variable "REGION" {
  default = "us-east-1"
}

variable "ACCOUNT" {
  default = "035274893828"
}

variable "CredSecret" {
  default = "liorm-aws-credentials-Mrmk2g"
}

####< NETWORK VARS >####
locals {
  private-us-east-1a-id = module.subnet_ids.private_subnet_ids[0]
  private-us-east-1b-id = module.subnet_ids.private_subnet_ids[1]
  public-us-east-1a-id  = module.subnet_ids.public_subnet_ids[0]
  public-us-east-1b-id  = module.subnet_ids.public_subnet_ids[1]
}

####< NODE VARS >####

variable "node_group_name" {
  default = "liorm-node-group"
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "instance_types" {
  default = ["m5.xlarge"]
}

variable "max_size" {
  default = "4"
}

variable "desired_size" {
  default = "2"
}

variable "node_name" {
  default = "liorm-node"
}