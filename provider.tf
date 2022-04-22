terraform {
  cloud {
    organization = "bayt"
    hostname     = "app.terraform.io"
    workspaces {
      name = "kali-aws"
    }
  }
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
    packer = {
      source  = "toowoxx/packer"
      version = "0.10.0"
    }
  }
}
provider "aws" {
  region     = var.aws_region
  profile    = var.aws_profile
  access_key = var.access_key
  secret_key = var.secret_key
}
provider "packer" {
}