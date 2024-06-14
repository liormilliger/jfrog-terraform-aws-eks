resource "aws_route_table" "liorm_route_table" {
  vpc_id = aws_vpc.liorm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.liorm_igw.id
  }

  tags = {
    Name = "liorm-route-table"
  }
}

resource "aws_route_table_association" "liorm_public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.liorm_route_table.id
}

# resource "aws_route_table" "private-routes-table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "ashrafk-private-routes-table"
#     provisioned_by = "Terraform"
#   }
# }

# resource "aws_route_table" "public-routes-table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "ashrafk-public-routes-table"
#     provisioned_by = "Terraform"
#   }
# }


# resource "aws_route_table_association" "private-eu-west-1a" {
#   subnet_id      = aws_subnet.private-eu-west-1a.id
#   route_table_id = aws_route_table.private-routes-table.id
# }

# resource "aws_route_table_association" "private-eu-west-1b" {
#   subnet_id      = aws_subnet.private-eu-west-1b.id
#   route_table_id = aws_route_table.private-routes-table.id
# }

# resource "aws_route_table_association" "public-eu-west-1a" {
#   subnet_id      = aws_subnet.public-eu-west-1a.id
#   route_table_id = aws_route_table.public-routes-table.id
# }

# resource "aws_route_table_association" "public-eu-west-1b" {
#   subnet_id      = aws_subnet.public-eu-west-1b.id
#   route_table_id = aws_route_table.public-routes-table.id
# }