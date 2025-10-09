


variable "cluster_name" {
description = "EKS cluster name"
type = string
default = "project"
}


variable "vpc_id" {
description = "VPC ID for ALB Controller"
type = string
}


variable "vpc_cni_version" {
description = "VPC CNI Add-on version"
type = string
}


# variable "kube_proxy_version" {
# description = "kube-proxy Add-on version"
# type = string
# }


# variable "coredns_version" {
# description = "CoreDNS Add-on version"
# type = string
# }


# variable "ebs_csi_version" {
# description = "EBS CSI Add-on version"
# type = string
# }