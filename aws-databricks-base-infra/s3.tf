# Who am I? (account-scoped uniqueness)
data "aws_caller_identity" "current" {}

# Tiny random suffix (e.g., "a1b2c3")
resource "random_id" "sfx" {
  byte_length = 3
}

locals {
  bucket_name = "${var.prefix}-rootbucket-${data.aws_caller_identity.current.account_id}-${random_id.sfx.hex}"
}

resource "aws_s3_bucket" "root_storage_bucket_syed_028" {
  bucket        = local.bucket_name
  force_destroy = true

  tags = merge(var.tags, {
    Name = local.bucket_name
  })
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.root_storage_bucket_syed_028.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_storage_bucket" {
  bucket = aws_s3_bucket.root_storage_bucket_syed_028.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket                  = aws_s3_bucket.root_storage_bucket_syed_028.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.root_storage_bucket_syed_028]
}

# Databricks will compute the correct policy for the *actual* name
data "databricks_aws_bucket_policy" "this" {
  bucket = aws_s3_bucket.root_storage_bucket_syed_028.bucket
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket     = aws_s3_bucket.root_storage_bucket_syed_028.id
  policy     = data.databricks_aws_bucket_policy.this.json
  depends_on = [aws_s3_bucket_public_access_block.root_storage_bucket]
}