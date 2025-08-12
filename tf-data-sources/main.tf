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

# 1️⃣ Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
    ENV  = "PROD"
  }
}

# 2️⃣ Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

# 3️⃣ Create Security Group
resource "aws_security_group" "my_sg" {
  name        = "my-sg-name"
  description = "Allow SSH and HTTP inbound"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg-name"
  }
}

# 4️⃣ Outputs for Step 2
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}

# Get existing VPC by ID
data "aws_vpc" "existing" {
  id = "vpc-0e45b54d5e50c7c35"
}

# Get existing private subnet by ID
data "aws_subnet" "private" {
  id = "subnet-03719d40778142d99"
}

# Get existing security group by ID
data "aws_security_group" "existing_sg" {
  id = "sg-05c978f6f0029b866"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create EC2 instance in existing private subnet
resource "aws_instance" "private_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.private.id
  vpc_security_group_ids      = [data.aws_security_group.existing_sg.id]
  associate_public_ip_address = false  # stays private

  tags = {
    Name = "my-private-ec2"
  }
}

# Outputs
output "ec2_id" {
  value = aws_instance.private_ec2.id
}

output "ec2_private_ip" {
  value = aws_instance.private_ec2.private_ip
}
