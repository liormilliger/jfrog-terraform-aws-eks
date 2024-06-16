# AWS-EKS IaaC with Terraform

This Repo contains Terraform (tf) configuration files that provisions EKS cluster with 2 nodes (m5-xlarge type)
Helm provider is provisioned to install EBS-CSI Driver to enable kubernetes pvcs create an EBS-pvs.

## Requirements

1. AWS Account
2. Terraform installed
3. AWSCLI installed and configured with the right credentials