module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.29.0"
  cluster_name    = "rishab-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = false

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids

#   control_plane_subnet_ids = module.vpc.public_subnets_cidr

  # EKS Managed Node Group
  eks_managed_node_groups = {
    node_group = {
      min_size     = 1
      max_size     = 1
      desired_size = 1
      instance_types = ["t2s.micro"]
    }
}

access_entries = {
    # One access entry with a policy associated
    dev = {
      principal_arn     = "arn:aws:iam::209479273772:user/dev"

      policy_associations = {
        dev_access-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
}