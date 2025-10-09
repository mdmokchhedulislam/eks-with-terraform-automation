output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_security_group" {
  value = aws_security_group.eks_cluster_sg.id
}

output "worker_node_role_arn" {
  value = aws_iam_role.worker_node_role.arn
}
