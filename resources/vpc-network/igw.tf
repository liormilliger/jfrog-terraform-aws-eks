resource "aws_internet_gateway" "liorm_igw" {
  vpc_id = aws_vpc.liorm_vpc.id
  tags = {
    Name = "liorm-igw"
  }
}

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "ashrafk-igw"
#     provisioned_by = "Terraform"
#   }
# }
