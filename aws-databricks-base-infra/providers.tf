
provider "databricks" {
  alias = "mws"

  host     = var.databricks_account_host
  username = var.databricks_username
  password = var.databricks_password
}
