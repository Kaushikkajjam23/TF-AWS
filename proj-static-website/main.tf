terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-west-2"
}

resource "random_id" "rand_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "mywebapp-bucket" {
  bucket = "demobucket-${random_id.rand_id.hex}"
}

resource "aws_s3_account_public_access_block" "mywebapp-bucket" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index_html" {
  source      = "./index.html"
  bucket      = aws_s3_bucket.mywebapp-bucket.bucket
  key         = "index.html"
  acl         = "public-read"
}

resource "aws_s3_object" "style_css" {
  source      = "./style.css"
  bucket      = aws_s3_bucket.mywebapp-bucket.bucket
  key         = "style.css"
  acl         = "public-read"
}

output "bucket_name" {
  value = aws_s3_bucket.mywebapp-bucket.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.mywebapp-bucket.id
}

output "random_id" {
  value = random_id.rand_id.hex
}