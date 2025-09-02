output "eks_addons" {
  description = "EKS addons managed by Terraform"
  value = {
    vpc_cni   = aws_eks_addon.vpc_cni.id
    kubeproxy = aws_eks_addon.kube_proxy.id
    coredns   = aws_eks_addon.coredns.id
  }
}