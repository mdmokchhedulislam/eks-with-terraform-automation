

# IAM Role for Service Accounts (IRSA) for Helm Add-ons
resource "aws_iam_role" "alb_controller_iam_role" {
  name = "eks-alb-controller-irsa"
  assume_role_policy = data.aws_iam_policy_document.irsa_alb.json
}

data "aws_iam_policy_document" "irsa_alb" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name       = var.cluster_name
  addon_name         = "vpc-cni"
  addon_version      = var.vpc_cni_version
  service_account_role_arn = aws_iam_role.alb_controller_iam_role.arn
}

# kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy_version
}

# # CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.coredns_version

}

# # EBS CSI Driver Add-on
resource "aws_eks_addon" "ebs_csi" {
  cluster_name      = var.cluster_name
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = var.ebs_csi_version
}
