terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  # change region if you need to for cost purposes, etc, but make sure to use a supported AMI
  region = "us-west-2"
}