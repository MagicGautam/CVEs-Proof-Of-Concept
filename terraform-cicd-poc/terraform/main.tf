#Terraform Block

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#Provider Block:

provider "aws" {
    region="eu-central-1"
    profile="default"
}



#Resource Block:

resource "aws_s3_bucket" "my-bucket" {
  bucket = "war-dog-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}