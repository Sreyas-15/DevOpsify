terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-statefile-bucket_devopsify" {
  bucket = "my-statefile-bucket-devopsify"

  tags = {
    Name        = "My bucket"
    Environment = "test"
  }
}


terraform {
  backend "s3" {
    bucket       = "my-statefile-bucket-devopsify"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}


