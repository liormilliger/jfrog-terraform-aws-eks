resource "aws_iam_role" "liorm-node-group-role" {
  name = "liorm_node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "liorm-eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.liorm-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "liorm-eks-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.liorm-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "liorm-ec2-container-registry-read-only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.liorm-node-group-role.name
}

resource "aws_eks_node_group" "node-group" {
  cluster_name    = var.cluster_name
  version         = var.cluster_version
  node_group_name = "liorm-node-group"
  node_role_arn   = aws_iam_role.liorm-node-group-role.arn

  subnet_ids = [
    local.public-us-east-1a-id,
    local.public-us-east-1b-id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["m5.xlarge"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
    nodeName = "liorm-node"
  }
  
  launch_template {
    name    = aws_launch_template.naming-nodes.name
    version = aws_launch_template.naming-nodes.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.liorm-eks-worker-node-policy,
    aws_iam_role_policy_attachment.liorm-eks-cni-policy,
    aws_iam_role_policy_attachment.liorm-ec2-container-registry-read-only,
    aws_eks_cluster.eks-cluster,
  ]

  tags = {
    provisioned_by = "Terraform"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# Naming Nodes
resource "aws_launch_template" "naming-nodes" {
  name = "naming-nodes"
  
  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name = "liorm-node"
    }
  }
}
