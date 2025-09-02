output "cluster_name" {
  value = aws_eks_cluster.this.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
output "cluster_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}
output "tags" {
  value = aws_eks_cluster.this.tags
  description = "Tags applied to the EKS cluster"
}
