variable "cluster_name" {
  default = "liorm-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
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

# variable "ashrafk_vpc_id" {
#   description = "The ID of the existing VPC"
#   type        = string
#   default     = "vpc-0731d5fd32fa569b4"
# }

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
#   default     = ["subnet-056c10809c1b54bce", "subnet-06775296b5b3edd16"]

# }

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
#   default     = ["subnet-022c7219c6e5ac31f", "subnet-03271d98b2d774f6e"]
# }

# # Private Route Table
# resource "aws_route_table" "private_routes_table" {
#   vpc_id = var.ashrafk_vpc_id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name            = "ashrafk-private-routes-table"
#     provisioned_by  = "Terraform"
#   }
# }

# # Public Route Table
# resource "aws_route_table" "public_routes_table" {
#   vpc_id = var.ashrafk_vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name            = "ashrafk-public-routes-table"
#     provisioned_by  = "Terraform"
#   }
# }