# Task: AWS IAM Management
# Provide user and roles info via YAML file
# Read the YAML file and process data
# Create IAM users
# Generate Passwords for the users
# Attach policy/roles to each users


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

locals {
  users_data = yamldecode(file("./users.yaml")).users
  users_role_pair = flatten([for user in local.users_data: [for role in user.roles: {
    username = user.username
    role     = role
  }] ])
}

output "output_users" {
  value = local.users_role_pair
}

#creating users
resource "aws_iam_user" "main" {
  for_each = toset(local.users_data[*].username)
  name     = each.value
}

#password creation
resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.main
  user=each.value.name
  password_length = 12

  lifecycle {
    ignore_changes = [ 
      password_length,
      password_reset_required,
      pgp_key,
     ]
  }
}

#Attaching policies to the users
resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.users_role_pair: "${pair.username}-${pair.role}" => pair
  }
  #kaushik-EC2Access={username=kaushik,role=AmazonEC2FullAccess} as unique key pair
  #kaushik-S3Access={username=kaushik,role=AmazonS3ReadOnlyAccess}
  #sham-S3Access={username=sham,role=AmazonS3ReadOnlyAccess}
  #raju-EC2Access={username=raju,role=AmazonEC2FullAccess}

  # FIX: Reference the actual user resource instead of just the username string
  user       = aws_iam_user.main[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
  
  # Optional: Explicit dependency (though the reference above should be sufficient)
  depends_on = [aws_iam_user.main]
}
