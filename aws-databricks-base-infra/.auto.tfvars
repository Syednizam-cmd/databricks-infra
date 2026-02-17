# terraform.auto.tfvars

# Common tags for all resources
tags = {
  Owner       = "Syed Nijamuddin"
  Project     = "databricks-foundation"
  Environment = "dev"
}

# Name prefix for resources
prefix = "dbx-dev"

# VPC / networking
cidr_block = "10.10.0.0/16"

# AWS region
region = "us-east-1"

# One or more role ARNs to assume (adjust type if your variables.tf expects map/list)
roles_to_assume = [
  "arn:aws:iam::211125523266:role/github-action-role"
]

# Databricks account-level credentials / settings
databricks_account_id   = "7474659942211802"
databricks_account_host = "https://accounts.cloud.databricks.com"