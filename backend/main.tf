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

resource "aws_dynamodb_table" "staefile_locking-table" {
  name           = "devopsify_state_file"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockId"

   attribute {
    name = "LockId"
    type = "S"
  }


}