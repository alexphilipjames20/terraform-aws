provider "aws" {
  region = var.region
}

module "eks-cluster" {
  source             = "../../modules/eks"
  cluster_name       = var.cluster_name
  role_name          = var.role_name
  vpc_subnets        = var.vpc_subnets
  node_group_name    = var.node_group_name
  node_instance_type = var.node_instance_type
  node_disk_size     = var.node_disk_size
  policy_arns        = var.policy_arns
  principal_arn      = var.principal_arn
  kubernetes_groups  = var.kubernetes_groups
  access_policy_arn  = var.access_policy_arn
  vpc_id             = var.vpc_id
}

data "aws_security_groups" "security_groups" {
  filter {
    name   = "tag:aws:eks:cluster-name"
    values = [var.cluster_name]
  }
}

resource "aws_ec2_tag" "security_groups" {
  for_each = toset(data.aws_security_groups.security_groups.ids)

  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name

  depends_on = [module.eks-cluster]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.aws_eks_cluster.cluster.name

  depends_on = [module.eks-cluster]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name, "--region", var.region]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
  }
}

data "aws_availability_zones" "available" {}

locals {
  region = var.region
  tags   = {
    Environment = "dev"
    Project     = var.cluster_name
  }
}


# Existing aws provider, module, data sources remain unchanged...

# Add Kubernetes provider configured to your EKS cluster:
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

# Add this resource to manage the aws-auth ConfigMap:
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::253490776927:user/alexphilipjames20@gmail.com"
        username = "alexphilipjames20"
        groups   = ["system:masters"]
      }
    ])
  }
}
