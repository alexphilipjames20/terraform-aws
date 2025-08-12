resource "aws_eks_cluster" "eks_cluster" {
  name    = var.cluster_name

  # Use created role if create_iam_role=true, else existing role ARN from data source
  role_arn = var.create_iam_role ? aws_iam_role.cluster_role[0].arn : data.aws_iam_role.existing_cluster_role[0].arn

  version = "1.32"

  vpc_config {
    subnet_ids              = var.vpc_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = aws_security_group.eks_cluster[*].id
  }

  access_config {
    authentication_mode                           = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
