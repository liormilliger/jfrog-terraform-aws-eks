# Terraform Managed AWS VPC & EKS Infrastructure

This repository includes a ready to deploy VPC and EKS infrastructure, without having to edit anything, expect for region, and the Name tags of the resources, as they all start with ashrafk.

To deploy the resources, run the following Terraform command:
```
terraform init
```
```
terraform plan
```
```
terraform apply
```
## Infrastructure design chart

The infrastructure was built with this design in mind:



![alt text](https://res.cloudinary.com/practicaldev/image/fetch/s--n_cbMy3c--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/cp8bxvvknzy6k7js7bi4.png)


## Replace the 'Name' tags

Since all of the resources start with ashrafk-[resource-name], because I created this in my test env, you would probably want to change that. Rather than doing it manually, you can remove the ashrafk- by using sed:
```
sed -i '' 's/ashrafk-//g' ./resources/*
```
