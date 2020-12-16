terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "eu-central-1"
  alias  = "prod-eu-central-1"
  assume_role {
    role_arn = format("arn:aws:iam::%s:role/%s", var.account_id, var.assume_role)
  }
}