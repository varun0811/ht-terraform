variable "cluster_name" {
  type        = string
  default = "ht-prod-cluster"
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "subnet_ids" {
  type = list(string)
  default = ["subnet-05db2a7311312b6a6","subnet-095bdcd403cde11e1"]
}
variable "tags" {
  type = map(string)
  default = {}
}