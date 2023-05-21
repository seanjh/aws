data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    key = "global/terraform.tfstate"
  }

  required_version = "~> 1.4.0"
}

provider "aws" {
  region = "us-east-2"
}
