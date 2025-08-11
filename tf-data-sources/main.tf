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

# Get latest Amazon Linux AMI
data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "aws_ami" {
  value = data.aws_ami.name.id
}

# Get Security Group by Name
data "aws_security_group" "name" {
  filter {
    name   = "group-name"
    values = ["my-sg-name"] # change to your SG name
  }
}

output "security_group" {
  value = data.aws_security_group.name.id
}

# Get VPC by Tag
data "aws_vpc" "name" {
  tags = {
    ENV  = "PROD"
    Name = "my-vpc" # ensure this matches exactly
  }
}

output "vpc_id" {
  value = data.aws_vpc.name.id
}

#availability zone
data "aws_availability_zones" "name" {
  state = "available"
}
output "aws_zones" {
  value = data.aws_availability_zones.name
}

#To get the account details
data "aws_caller_identity" "name" {
  
}
output "caller_info" {
  value = data.aws_caller_identity.name
}

#AWS region
data "aws_region" "name" {
  
}
output "region_name" {
  value = data.aws_region.name
}
# Create EC2 Instance
resource "aws_instance" "myserver" {
  ami           = data.aws_ami.name.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.name.id]
  subnet_id = element(data.aws_subnet_ids.example.ids, 0) # if needed

  tags = {
    Name = "MyServer"
  }
}
