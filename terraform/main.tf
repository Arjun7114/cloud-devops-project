# ===========================================================================
#  Phase 5 (STABLE VERSION) — EKS cluster on AWS with Terraform
#  Change: pinned Kubernetes to 1.31 (mature/stable) instead of 1.33, which
#  has a known node-health issue with the newest node images. Public-subnet
#  nodes + explicit disk size for maximum reliability.
# ===========================================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # Mumbai
}

locals {
  cluster_name = "cloud-devops-eks"
  region       = "ap-south-1"
}

# ---------------------------------------------------------------------------
# 1. NETWORKING (VPC)
# ---------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${local.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ---------------------------------------------------------------------------
# 2. THE KUBERNETES CLUSTER (EKS) + WORKER NODES
# ---------------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name = local.cluster_name

  # >>> KEY FIX: use the stable, battle-tested 1.31 instead of newest 1.33.
  kubernetes_version = "1.31"

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.small"]
      # Explicit disk size avoids a disk-capacity warning seen on some images.
      disk_size    = 20
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
