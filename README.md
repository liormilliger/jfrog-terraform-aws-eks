# AWS-EKS IaaC with Terraform

This Repo contains Terraform (tf) configuration files that provisions EKS cluster with 2 nodes (m5-xlarge type)
Helm provider is provisioned to install EBS-CSI Driver to enable kubernetes pvcs create an EBS-pvs.

## Requirements

1. AWS Account
2. Terraform installed
3. AWSCLI installed and configured with the right credentials
4. kubectl installed
5. Create credentials for your AWS IAM USER
6. Create Secret in SecretManager with your IAM USER CREDENTIALS (You would need its ARN)
7. Create an S3 bucket with a unique name, and within it a folder named data

## Operate

Before you start terraform - you will need to edit few things:

1. Update ```./main.tf``` with your s3 bucket name

```
variable "bucket_name" {
  description = "S3 bucket as a backend"
  default = "<Your Bucket Name>"
}
```

2. Update ```./resources/vpc-network/variables.tf```
with cluster name and vpc name and if needed - cidr blocks

3. update ```./resources/eks-cluster/variables.tf```
change resource names with your name prefix, all but this:

```
variable "CredSecret" {
  default = "<Your AWS Secret Name>"
}
```

now all should be ready - save all files!!!



```terraform init```
From the working directory in which main.tf run terraform init
this command will initialize terraform and install the required providers

```terraform plan```
See that all resources and plan goes without errors

```terraform apply --auto-approve```


## Modules Structure
<img width="177" alt="Screenshot 2024-06-16 at 14 51 14" src="https://github.com/liormilliger/jfrog-terraform-aws-eks/assets/64707466/79d08ced-40a3-4b6d-bb74-cbc2dd6abb98">

This structure contains 2 modules - one for vpc (./resources/vpc-network) and one for the cluster (./resources/eks-cluster)
These modules are being called through the main.tf that resides in our root working folder

### ROOT WORKING FOLDER

This folder will contain main.tf file that will declare providers and modules,
variable.tf file to contain dynamic info as variables
it may contain outputs.tf file if we want to output anything to stdout at the end of the terraform apply process
and it can contain terraform.tfvars file that will hold secrets and info that we dont want to share

### EKS CLUSTER MODULE

This module contains 2 primary files and a variables.tf file.
the variables.tf file allows to concentrate all our dynamic input in one place and to use it
as variables within the 2 other files.

eks.tf
this file contains the IAM roles and definition for the EKS cluster,
it also has the helm provider and EBS-CSI secret we created in the pre-requisites to install EBS-CSI-Driver 

node-group.tf
A cluster needs nodes in order to work. This file creates a node group with all the IAM roles and permissions
including node names and scaling config

### VPC MODULE
When setting up AWS EKS cluster - it requires setting up a vpc as well, hence the vpc module.

In the vpc module we set the cidr block for the vpc (vpc.tf), the subnets (subnets.tf), internet gateway (igw.tf), routing tables and routes association to the routing table (routes.tf)

