terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Sampleserver" {
  ami           = "ami-08a6efd148b1f7504"
  instance_type = var.aws_instance_type  # Fixed: Use the variable instead of hardcoded value

  root_block_device {
    delete_on_termination = true
    volume_size          = var.ec2_config.v_size
    volume_type          = var.ec2_config.v_type
  }
  
  tags = merge(var.additional_tags,{
    Name = local.name
  })
}
locals {
  owner = "Kaushik"
  name  = "SampleServer"
}

