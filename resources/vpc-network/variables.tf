variable "cluster_name" {
  default = "liorm-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
}

variable "vpc_name" {
  default = "liorm-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.64.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.64.10.0/24", "10.64.20.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.64.1.0/24", "10.64.2.0/24"]
}
