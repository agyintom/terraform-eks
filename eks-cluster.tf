module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "~> 20.34"
  cluster_name     = local.cluster_name
  cluster_version  = var.kubernetes_version
  subnet_ids       = module.vpc.private_subnets
  enable_irsa      = true

  tags = {
    cluster = "demo"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2023_x86_64_STANDARD"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {
    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }

  # ---- Access Entries ----
  authentication_mode = "API_AND_CONFIG_MAP"

  access_entries = {
    github_actions = {
      principal_arn = var.github_actions_iam_user_arn
      type          = "STANDARD"
      username      = "github-actions"

      policy_associations = {
        edit = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            type       = "namespace"
            namespaces = ["default"]
          }
        }
      }
    }

    admin = {
      principal_arn = var.admin_iam_user_arn
      type          = "STANDARD"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    node_group = {
      principal_arn = var.node_group_role_arn
      type          = "EC2_LINUX"
    }
  }
}