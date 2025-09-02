variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
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
  default     = "v1.11.4-eksbuild.2"
}

variable "ebs_csi_version" {
  type        = string
  default     = "latest"
}

variable "enable_ebs_csi" {
  type        = bool
  default     = true
}

variable "pod_identity_agent_version" {
  type    = string
}
