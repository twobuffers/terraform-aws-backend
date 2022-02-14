# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create resources for state stored in S3 backend
#
# TF config created based on:
# - https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
# - https://github.com/gruntwork-io/intro-to-terraform/blob/master/s3-backend/main.tf
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = var.region
}

# ------------------------------------------------------------------------------
# CREATE THE S3 BUCKET
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "terraform_state" {
  # checkov:skip=CKV_AWS_18 tfsec:ignore:AWS002 - Access logging is not needed for this bucket.
  # checkov:skip=CKV_AWS_52 - The bucket stores generated files. MFA delete protection is not needed.
  bucket = "${var.namespace}-${var.env}-terraform-state"
  # state files
  force_destroy = true # TODO: Make this optional
  # Enable versioning by default
  versioning {
    enabled = true
    # TODO: Consider adding optional variable to enable MFA delete protection.
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = var.tags
}

# ------------------------------------------------------------------------------
# CREATE THE DYNAMODB TABLE
#
# Warning
# The key here has to be "LockID".
# ------------------------------------------------------------------------------

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.namespace}-${var.env}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.tags
  # checkov:skip=CKV_AWS_28:"Point in time recovery" is not necessary for terraform locks table.
}
