################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "./modules/vpc"

  main-region = var.main-region
  profile     = var.profile
}

################################################################################
# EKS Cluster Module
################################################################################

module "eks" {
  source = "./modules/eks-cluster"

  main-region = var.main-region
  profile     = var.profile
  rolearn     = var.rolearn

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

################################################################################
# AWS ALB Controller
################################################################################

module "aws_alb_controller" {
  source = "./modules/aws-alb-controller"

  main-region  = var.main-region
  env_name     = var.env_name
  cluster_name = var.cluster_name

  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
}

################################################################################
# HPA Deploy
################################################################################

resource "helm_release" "metrics-server" {
    name       = "metrics-server"

    repository = "https://kubernetes-sigs.github.io/metrics-server/"
    chart      = "metrics-server"
    namespace  = "kube-system"
    version    = "3.12.1"

    set {
        name   = "replicas"
        value  = 2
    }
}