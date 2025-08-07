provider "helm" {
  kubernetes = {
    config_path            = "~/.kube/config"
    host                   = aws_eks_cluster.eks-cluster.endpoint
    #cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.cluster_ca_certificate)
  }
}

# data "aws_eks_cluster_auth" "cluster" {
#   name = aws_eks_cluster.eks-cluster.name
# }

# data "aws_eks_cluster" "eks-cluster" {
#   name = var.cluster_name
# }

# provider "kubernetes" {
#   host                   = aws_eks_cluster.eks-cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   # depends_on = [
#   #   aws_eks_cluster.this
#   # ]
# }
# ## Use this when you want to execute kubectl commands from TF
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
    command = "aws eks --region ${var.REGION} update-kubeconfig --name ${aws_eks_cluster.eks-cluster.name}"
  }
}

# Credentials for EBS-CSI-DRIVER

data "aws_secretsmanager_secret" "aws-credentials" {
  arn = "arn:aws:secretsmanager:${var.REGION}:${var.ACCOUNT}:secret:${var.CredSecret}"
}

data "aws_secretsmanager_secret" "ebs-credentials" {
  arn = "arn:aws:secretsmanager:${var.REGION}:${var.ACCOUNT}:secret:${var.EbsCredSecret}"
}

data "aws_secretsmanager_secret_version" "ebs-csi-secret" {
  secret_id = data.aws_secretsmanager_secret.ebs-credentials.id
}

resource "kubernetes_secret" "csi_secret" {
  metadata {
    name = "ebs-csi-secret"
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

  depends_on = [ aws_eks_cluster.eks-cluster ]
}