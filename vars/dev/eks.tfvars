region = "ap-south-1"

cluster_name       = "terraform-eks-cluster-poc"
role_name          = "eks-cluster-role"
vpc_subnets        = ["subnet-0de6dcb0784031eaa", "subnet-0d2df5601dd8e3404"]
node_group_name    = "terraform-eks-node-group"
node_instance_type = ["t3.medium"]
node_disk_size     = 20

policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]

principal_arn     = "arn:aws:iam::253490776927:user/eks-user"
kubernetes_groups = ["group-1"]

# NOTE: This ARN format may not exist exactly as is, so confirm this for your account or use a custom access policy
access_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

# Security group variables
vpc_id = "vpc-0137dcbe39b5027c8"

# Custom variables
access_entry_type             = "EC2_LINUX"
cluster_ip_family             = "ipv4"
create                        = true
create_access_entry           = true
create_iam_role               = false
create_node_iam_role          = false
cluster_iam_role_name    = "eks-cluster-role"
node_group_iam_role_name = "eks-node-group-role"

create_instance_profile       = true
create_pod_identity_association = false
enable_irsa                  = false
enable_pod_identity          = false
enable_spot_termination      = false
enable_v1_permissions        = true

iam_policy_description        = "EKS IAM policy"
iam_policy_name               = "eks-custom-policy"
iam_policy_path               = "/"
iam_policy_statements         = []
iam_policy_use_name_prefix    = false

iam_role_description          = "EKS IAM role"
iam_role_max_session_duration = 3600
iam_role_name                 = "eks-cluster-role"
iam_role_path                 = "/"
iam_role_permissions_boundary_arn = null
iam_role_policies             = {}
iam_role_tags                 = {}
iam_role_use_name_prefix      = false

irsa_assume_role_condition_test  = "StringEquals"
irsa_namespace_service_accounts   = []
irsa_oidc_provider_arn            = null
namespace                       = "karpenter"
node_iam_role_additional_policies = {}
node_iam_role_arn               = null
node_iam_role_attach_cni_policy = true
node_iam_role_description      = "Node IAM role"
node_iam_role_max_session_duration = 3600
node_iam_role_name             = "eks-node-group-role"
node_iam_role_path             = "/"
node_iam_role_permissions_boundary = null
node_iam_role_tags             = {}
node_iam_role_use_name_prefix  = false

queue_kms_data_key_reuse_period_seconds = 300
queue_kms_master_key_id         = null
queue_managed_sse_enabled       = true
queue_name                     = "karpenter-queue"

rule_name_prefix               = "karpenter"
service_account               = "karpenter-sa"

tags = {
  Environment = "dev"
  Project     = "eks"
}

ami_id_ssm_parameter_arns = []
