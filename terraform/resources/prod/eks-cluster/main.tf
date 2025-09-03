provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source     = "../../../modules/eks-cluster"
  cluster_name = var.cluster_name
  region     = var.region
  subnet_ids = var.subnet_ids        # pass private subnets
  tags       = var.tags
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}
output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}
output "cluster_ca_data" {
  value = module.eks_cluster.cluster_certificate_authority_data
}
output "cluster_role_arn" {
  value = module.eks_cluster.cluster_role_arn
}
