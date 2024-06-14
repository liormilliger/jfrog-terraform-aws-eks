# provider "aws" {
#   region = "us-east-1"
# }

resource "aws_vpc" "liorm_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "liorm-vpc"
  }
}

# resource "aws_vpc" "vpc" {
#   cidr_block = "10.0.0.0/16"
  
#   tags = {
#     Name = "ashrafk-vpc"
#     provisioned_by = "Terraform"
#   }
# }
