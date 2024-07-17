terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "ec2-demo" {
  ami           = "ami-0649bea3443ede307"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}