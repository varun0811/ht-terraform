variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default = "ht-prod-cluster"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for resources"
}

variable "vpc_cni_version" {
  type        = string
  default     = "v1.20.0-eksbuild.1"
}

variable "kube_proxy_version" {
  type        = string
  default     = "v1.32.0-eksbuild.2"
}

variable "coredns_version" {
  type        = string
  default     = "v1.11.3-eksbuild.2"
}

variable "pod_identity_agent_version" {
  type    = string
  default = "v1.3.2-eksbuild.2"
}
