resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.liorm_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "us-east-1a" # Example availability zone, adjust as needed
  tags = {
    Name = "liorm-private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.liorm_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = "us-east-1b" # Example availability zone, adjust as needed
  map_public_ip_on_launch = true
  tags = {
    Name = "liorm-public-subnet-${count.index}"
  }
}

# resource "aws_subnet" "private-eu-west-1a" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.0.0/19"
#   availability_zone = "eu-west-1a"

#   tags = {
#     "Name" = "ashrafk-private-eu-west-1a"
#     "kubernetes.io/role/internal-elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#     provisioned_by = "Terraform"

#   }
# }

# resource "aws_subnet" "private-eu-west-1b" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "eu-west-1b"

#   tags = {
#     "Name" = "ashrafk-private-eu-west-1b"
#     "kubernetes.io/role/internal-elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#     provisioned_by = "Terraform"
#   }
# }

# resource "aws_subnet" "public-eu-west-1a" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.64.0/19"
#   availability_zone = "eu-west-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name" = "ashrafk-public-eu-west-1a"
#     "kubernetes.io/role/elb"                    = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#     provisioned_by = "Terraform"
#   }
# }

# resource "aws_subnet" "public-eu-west-1b" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.96.0/19"
#   availability_zone       = "eu-west-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name" = "ashrafk-public-eu-west-1b"
#     "kubernetes.io/role/elb"                    = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#     provisioned_by = "Terraform"
#   }
# }