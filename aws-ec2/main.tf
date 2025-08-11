terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.7.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}
resource "aws_instance" "myserver" {
    ami="ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    tags = {
        Name = "MyServer"
    }
}