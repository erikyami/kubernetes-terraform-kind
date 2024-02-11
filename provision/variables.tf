variable "cluster_name" {
  type    = string
  default = "cajuina"
}

variable "cluter_k8s_version" {
  type = string
  default = "kindest/node:v1.29.1"
}
