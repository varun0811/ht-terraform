module "eks_addons" {
  source = "../../modules/eks-addons"

  cluster_name       = var.cluster_name
  vpc_cni_version    = var.vpc_cni_version
  coredns_version    = var.coredns_version
  kube_proxy_version = var.kube_proxy_version
  pod_identity_agent_version = var.pod_identity_agent_version

}
