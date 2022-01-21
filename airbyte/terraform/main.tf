terraform {
  backend "s3" {
    bucket = "ctbucket12122-tf-state"
    key = "ctcluster1/airbyte/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.62.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_eks_cluster" "cluster" {
  name = "ctcluster1"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "ctcluster1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


module "aws" {
  source = "./aws"

### BEGIN MANUAL SECTION <<aws>>

### END MANUAL SECTION <<aws>>


  namespace = "airbyte"
  cluster_name = "ctcluster1"
  airbyte_bucket = "ctbucket12122-ctcluster1-airbyte"

}
