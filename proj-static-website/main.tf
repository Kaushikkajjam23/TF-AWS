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

resource "random_id" "rand_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "mywebapp-bucket" {
  bucket = "demobucket-${random_id.rand_id.hex}"
}

# Enable ACLs for the bucket
resource "aws_s3_bucket_ownership_controls" "mywebapp-bucket" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "mywebapp-bucket" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket_ownership_controls.mywebapp-bucket]
}

# Website configuration
resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  source      = "./index.html"
  bucket      = aws_s3_bucket.mywebapp-bucket.bucket
  key         = "index.html"
  acl         = "public-read"
  content_type = "text/html"
  
  depends_on = [aws_s3_bucket_public_access_block.mywebapp-bucket]
}

resource "aws_s3_object" "styles_css" {
  source      = "./styles.css"
  bucket      = aws_s3_bucket.mywebapp-bucket.bucket
  key         = "styles.css"
  acl         = "public-read"
  content_type = "text/html"
  
  depends_on = [aws_s3_bucket_public_access_block.mywebapp-bucket]
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

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}

resource "aws_s3_bucket_policy" "mywebapp_policy" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mywebapp-bucket.arn}/*"
      },
      {
        Sid       = "PublicPutObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.mywebapp-bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.mywebapp-bucket]
}