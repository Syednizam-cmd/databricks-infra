data "databricks_aws_assume_role_policy" "this" {
  provider    = databricks.mws
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role_test" {
  name               = "${var.prefix}-crossaccount-${random_string.suffix.result}"
  #name               = "${var.prefix}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.tags
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

data "databricks_aws_crossaccount_policy" "this" {
  provider = databricks.mws
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = [data.databricks_aws_crossaccount_policy.this.json]

  statement {
    sid       = "allowPassCrossServiceRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = var.roles_to_assume
  }

}

resource "aws_iam_role_policy" "this" {
  name   = "${var.prefix}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.aws_iam_policy_document.this.json
}