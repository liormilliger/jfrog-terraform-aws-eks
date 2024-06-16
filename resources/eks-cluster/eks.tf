resource "aws_iam_role" "eks-cluster-iam-role" {
  name = "${var.cluster_name}-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    provisioned_by = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-iam-role.name
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster-iam-role.arn
  
  tags = {
    provisioned_by = "Terraform"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  vpc_config {
    subnet_ids = [
      local.private-us-east-1a-id,
      local.private-us-east-1b-id,
      local.public-us-east-1a-id,
      local.public-us-east-1a-id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks-cluster-policy]
}

provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config"
    host                   = aws_eks_cluster.eks-cluster.endpoint
    # cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.cluster_ca_certificate)
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks-cluster.name
}

data "aws_eks_cluster" "eks-cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token

}

# provider "kubectl" {
#   host                   = aws_eks_cluster.eks-cluster.cluster_endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.cluster_ca_certificate)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster.name]
#   }
# }

resource "null_resource" "update_kubeconfig" {
  # Ensures this runs after the EKS cluster has been created
  depends_on = [aws_eks_cluster.eks-cluster]

  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.eks-cluster.name}"
  }
}

# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   namespace  = "kube-system"
#   chart      = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
  
#   depends_on = [aws_eks_cluster.eks-cluster]
# }


# Credentials for EBS-CSI-DRIVER

data "aws_secretsmanager_secret" "aws-credentials" {
  arn = "arn:aws:secretsmanager:us-east-1:035274893828:secret:liorm-aws-credentials-Mrmk2g"
}

data "aws_secretsmanager_secret_version" "ebs-csi-secret" {
  secret_id = data.aws_secretsmanager_secret.aws-credentials.id
}

resource "kubernetes_secret" "csi_secret" {
  metadata {
    name = "aws-secret"
  }

  data = {
    key = data.aws_secretsmanager_secret_version.ebs-csi-secret.id
  }
}

# CSI Driver Release
resource "helm_release" "csi-driver" {
  name = "aws-ebs-csi-driver"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"

  depends_on = [ kubernetes_secret.csi_secret ]
}
