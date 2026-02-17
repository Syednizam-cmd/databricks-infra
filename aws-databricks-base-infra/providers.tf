provider "aws" {
  region = var.region
}

# Account-level provider (required for provisioning workspace)
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  auth_type  = "aws"
}
