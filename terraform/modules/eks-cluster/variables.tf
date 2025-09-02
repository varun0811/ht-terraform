variable "cluster_name" {
  type        = string
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "subnet_ids" {
  type = list(string)
}
variable "tags" {
  type = map(string)
  default = {}
}