variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "subnet_ids" {
  description = "Private subnets for worker nodes"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key name for EC2 instances"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = "Desired capacity for node ASG"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum size of ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of ASG"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
