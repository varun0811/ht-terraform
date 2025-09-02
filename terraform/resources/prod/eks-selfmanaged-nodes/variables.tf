
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "tags" {
  description = "Tags to attach to resources"
  type        = map(string)
  default     = {}
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Optional SSH key name for nodes"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}
