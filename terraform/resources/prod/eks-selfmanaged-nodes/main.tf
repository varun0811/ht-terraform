provider "aws" {
  region = var.region
}

# Pull existing cluster info
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "ht-prod-terraform-state"
    key    = "eks/cluster/terraform.tfstate"
    region = var.region
  }
}

# Pull existing VPC info
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ht-prod-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

# Call self-managed node module and pass all required values
module "eks_selfmanaged_nodes" {
  source       = "../../modules/eks-selfmanaged"
  cluster_name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
  region       = var.region
  subnet_ids   = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  instance_type    = "t3.small"
  tags         = { Name = "selfmanaged-nodes" }
  key_name         = "eks-access"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3
}

# Kubernetes provider for aws-auth
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


