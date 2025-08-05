terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.7.0"
    }
  }
  backend "s3" {
    bucket = "demobucket-bf89b35eaedb1dae"
    key="backend.tfstate"
    region = "us-east-1"
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