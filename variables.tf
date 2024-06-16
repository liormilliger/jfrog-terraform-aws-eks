variable "bucket_name" {
  description = "S3 bucket as a backend"
  default = "liorm-jfrog-tfstate"
}

variable "tfstate_folder" {
    description = "folder within the S3 bucket for the tfstate file"
    default = "data/terraform.tfstate"
}