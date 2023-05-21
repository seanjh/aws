data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  #backend "s3" {
  #bucket         = "117936299034-terraform-state"
  #key            = "management/terraform.tfstate"
  #dynamodb_table = "terraform-locks"
  #encrypt        = true
  #}

  required_version = "~> 1.4.0"
}

provider "aws" {
  region = "us-east-2"
}
