# # Fetching the current IP address using an external data source
# data "http" "my_ip" {
#   url = "https://checkip.amazonaws.com/"
# }

# # Convert the fetched IP to a CIDR format
# locals {
#   my_ip = "${trimspace(data.http.my_ip.response_body)}/32"
# }

# resource "aws_security_group" "liorm_allow_my_ip" {
#   name        = "allow_inbound_my_ip"
#   description = "Security group to allow inbound traffic from my IP only and all outbound traffic"
#   vpc_id = var.my_vpc
#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow inbound traffic from my IP only
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [local.my_ip]

#    # cidr_blocks = [cidrhost(data.http.my_ip.response_body, 32)]
#   }
# }


