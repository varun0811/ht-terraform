terraform {
  backend "s3" {
    bucket         = "ht-prod-terraform-state"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ht-prod-terraform-lock"
    encrypt        = true
  }
}

