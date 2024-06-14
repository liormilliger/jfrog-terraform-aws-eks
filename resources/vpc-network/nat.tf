# resource "aws_eip" "eip" {
#   vpc = true

#   tags = {
#     Name = "ashrafk-eip"
#     provisioned_by = "Terraform"
#   }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.public-eu-west-1a.id

#   tags = {
#     Name = "ashrafk-nat"
#     provisioned_by = "Terraform"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }
