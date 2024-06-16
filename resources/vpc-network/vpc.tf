resource "aws_vpc" "liorm_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "liorm-vpc"
  }
}
