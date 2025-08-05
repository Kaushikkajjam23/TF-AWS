terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.7.0"
    }
    random={
        source = "hashicorp/random"
        version = "3.6.2"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

resource "random_id" "rand_id" {
    byte_length = 8
}

resource "aws_s3_bucket" "demobucket" {
    bucket = "demobucket-${random_id.rand_id.hex}"
}
resource "aws_s3_object" "bucketdata" {
    source = "./myfile.txt"
    bucket = aws_s3_bucket.demobucket.bucket
    key    = "mydata.txt"
}

output "name"{
    value=random_id.rand_id.hex
}