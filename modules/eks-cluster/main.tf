################################################################################
# EKS Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8.5"

  cluster_name    = "terraform-eks"
  cluster_version = "1.29"

   providers = {
    aws = aws.ap-northeast-2
  }

  cluster_endpoint_public_access = true

  create_kms_key              = false
  create_cloudwatch_log_group = false
  cluster_encryption_config   = {}

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m7g.large","m7g.xlarge"]
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }

  eks_managed_node_groups = {
    blue = {
	min_size     = 1
	max_size     = 10
	desired_size = 1
	}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t4g.medium"]
      capacity_type  = "SPOT"
    }
  }

 # aws_auth_roles = [
 #   {
 #     rolearn  = var.rolearn
 #     username = "jhyoonzi"
 #     groups   = ["system:masters"]
 #   },
 # ]


  tags = {
    env       = "alpha"
    terraform = "true"
  }
}