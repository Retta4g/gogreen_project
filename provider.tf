terraform {
  cloud {
    organization = "02-spring-cloud"

    workspaces {
      name = "Gogreen_Project"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}