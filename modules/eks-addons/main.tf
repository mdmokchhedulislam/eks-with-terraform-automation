

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
# resource "aws_eks_addon" "kube_proxy" {
#   cluster_name      = var.cluster_name
#   addon_name        = "kube-proxy"
#   addon_version     = var.kube_proxy_version
#   resolve_conflicts = "OVERWRITE"
# }

# # CoreDNS Add-on
# resource "aws_eks_addon" "coredns" {
#   cluster_name      = var.cluster_name
#   addon_name        = "coredns"
#   addon_version     = var.coredns_version
#   resolve_conflicts = "OVERWRITE"
# }

# # EBS CSI Driver Add-on
# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name      = var.cluster_name
#   addon_name        = "aws-ebs-csi-driver"
#   addon_version     = var.ebs_csi_version
#   resolve_conflicts = "OVERWRITE"
# }

# # Helm AWS Load Balancer Controller
# resource "helm_release" "aws_load_balancer_controller" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   depends_on = [aws_eks_addon.vpc_cni]

#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }
#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }
#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }
#   set {
#     name  = "serviceAccount.roleARN"
#     value = aws_iam_role.alb_controller_iam_role.arn
#   }
#   set {
#     name  = "region"
#     value = var.region
#   }
#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }
# }

# # Metrics Server Helm Add-on
# resource "helm_release" "metrics_server" {
#   name       = "metrics-server"
#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart      = "metrics-server"
#   namespace  = "kube-system"
# }

# # Cluster Autoscaler Helm Add-on
# resource "helm_release" "cluster_autoscaler" {
#   name       = "cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"
#   namespace  = "kube-system"

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = var.cluster_name
#   }
#   set {
#     name  = "awsRegion"
#     value = var.region
#   }
#   set {
#     name  = "rbac.serviceAccount.create"
#     value = "true"
#   }
# }

# # Fluent Bit for CloudWatch Logs
# resource "helm_release" "fluent_bit" {
#   name       = "fluent-bit"
#   repository = "https://fluent.github.io/helm-charts"
#   chart      = "fluent-bit"
#   namespace  = "kube-system"

#   set {
#     name  = "backend.type"
#     value = "cloudwatch"
#   }
#   set {
#     name  = "aws.region"
#     value = var.region
#   }
# }

# # Prometheus + Grafana Monitoring
# resource "helm_release" "prometheus" {
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   namespace  = "monitoring"
# }
