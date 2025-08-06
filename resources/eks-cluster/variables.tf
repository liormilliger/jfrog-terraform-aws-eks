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
  default = "eu-west-1"
}

variable "ACCOUNT" {
  default = "035274893828"
}

variable "CredSecret" {
  default = "liorm-aws-credentials-iGQ1qf"
}

variable "EbsCredSecret" {
  default = "ebs-csi-secret-SLA4bc"
}

####< NETWORK VARS >####
locals {
  private-eu-west-1a-id = module.subnet_ids.private_subnet_ids[0]
  private-eu-west-1b-id = module.subnet_ids.private_subnet_ids[1]
  public-eu-west-1a-id  = module.subnet_ids.public_subnet_ids[0]
  public-eu-west-1b-id  = module.subnet_ids.public_subnet_ids[1]
}

####< NODE VARS >####

variable "node_group_name" {
  default = "liorm-node-group"
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "instance_types" {
  default = ["t3a.xlarge"]
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