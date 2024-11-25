module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.29.0"
  cluster_name    = "rishab-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = false

#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

#   control_plane_subnet_ids = module.vpc.public_subnets_cidr

  # EKS Managed Node Group
  eks_managed_node_group_defaults = {
    instance_types         = ["t2.micro"]
    # vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    tags = {
    Name = "worker node group"
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




  tags = {
    Name = "rishab-cluster"
  }
}