data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster_role" {
  count              = var.create_iam_role ? 1 : 0
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count      = var.create_iam_role ? 1 : 0
  policy_arn = var.policy_arns[0]
  role       = aws_iam_role.cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  count      = var.create_iam_role ? 1 : 0
  policy_arn = var.policy_arns[1]
  role       = aws_iam_role.cluster_role[0].name
}

# Data source to get existing cluster role if not creating
data "aws_iam_role" "existing_cluster_role" {
  count = var.create_iam_role ? 0 : 1
  name  = var.cluster_iam_role_name
}

# Node group assume role
data "aws_iam_policy_document" "node_group_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "node-group-iam-role" {
  count              = var.create_node_iam_role ? 1 : 0
  name               = "eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count      = var.create_node_iam_role ? 1 : 0
  policy_arn = var.policy_arns[2]
  role       = aws_iam_role.node-group-iam-role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count      = var.create_node_iam_role ? 1 : 0
  policy_arn = var.policy_arns[3]
  role       = aws_iam_role.node-group-iam-role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count      = var.create_node_iam_role ? 1 : 0
  policy_arn = var.policy_arns[5]
  role       = aws_iam_role.node-group-iam-role[0].name
}

# Data source to get existing node group role if not creating
data "aws_iam_role" "existing_node_group_role" {
  count = var.create_node_iam_role ? 0 : 1
  name  = var.node_group_iam_role_name
}
