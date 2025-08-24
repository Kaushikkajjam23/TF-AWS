terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.7.0"
        }
    }
}
provider "aws" {
    region = var.region
}
locals {
    project= "my_project-01"
}
resource "aws_vpc" "myvpc" {
        cidr_block = "10.0.0.0/16"
        tags = {
                Name="${local.project}-vpc"
        }
}
resource "aws_subnet" "main" {
        vpc_id     = aws_vpc.myvpc.id
        cidr_block = "10.0.${count.index}.0/24"
        count = 2
        tags = {
            Name="${local.project}-subnet-${count.index + 1}"
        }
}
#Creating 4 EC2 instances
resource "aws_instance" "main" {
    ami="ami-08a6efd148b1f7504"
        instance_type = "t2.micro"
        tags = {
                Name = "${local.project}-instance-${count.index }"
        } 
        count = 4
        subnet_id = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))

}

output "aws_subnet_id" {
    value = aws_subnet.main[*].id
}

# Task 1 - Create 2 subnets
# This task provisions two subnets within the VPC:
# - Subnet 1: 10.0.0.0/24
# - Subnet 2: 10.0.1.0/24
# Each subnet is tagged for identification.

# Task 2 - Create 4 EC2 instances
# This task provisions four EC2 instances:
# - EC2 instance 1 and 2 are launched in Subnet 1 (10.0.0.0/24).
# - EC2 instance 3 and 4 are launched in Subnet 2 (10.0.1.0/24).
# The subnet assignment is handled by mapping the instance index to the subnet index.