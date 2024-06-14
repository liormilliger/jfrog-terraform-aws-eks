module "subnet_ids" {
  source = "../vpc-network/"
}

variable "cluster_name" {
  default = "liorm-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
}

locals {
  private-us-east-1a-id = module.subnet_ids.private_subnet_ids[0]
  private-us-east-1b-id = module.subnet_ids.private_subnet_ids[1]
  public-us-east-1a-id  = module.subnet_ids.public_subnet_ids[0]
  public-us-east-1b-id  = module.subnet_ids.public_subnet_ids[1]
}
