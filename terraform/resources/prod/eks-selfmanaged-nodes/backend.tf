terraform {
  backend "s3" {
    bucket         = "ht-prod-terraform-state"   # Same backend bucket
    key            = "eks/self-managed-nodes/terraform.tfstate"
    region         = "ap-south-1"            # Your AWS region
    dynamodb_table = "ht-prod-terraform-lock"   # DynamoDB for state locking
    encrypt        = true
  }
}