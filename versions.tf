terraform {
  required_version = ">= 1.5.0"

  # State remoto: publica os outputs deste repositório (host_ip) e permite ler o
  # state do repositório Lambda-Function-Serverless (security group da Lambda).
  backend "s3" {
    bucket = "techchallenge-terraform-state-s3"
    key    = "database/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Usado apenas para liberar, no security group do EC2, o acesso da Lambda de
# autenticação (Lambda-Function-Serverless) ao Postgres.
provider "aws" {
  region = var.aws_region
}
