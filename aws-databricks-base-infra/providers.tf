provider "aws" {
  region = var.region
}

provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id

  auth_type    = "aws"
  aws_provider = aws
}

provider "databricks" {
  host = databricks_mws_workspaces.this.workspace_url

  auth_type    = "aws"
  aws_provider = aws
}