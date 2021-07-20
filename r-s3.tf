data "aws_iam_policy_document" "prevent_unencrypted_uploads" {
  statement {
    sid = "DenyIncorrectEncryptionHeader"

    effect = "Deny"

    not_principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "AES256",
        "aws:kms"
      ]
    }
  }

  statement {
    sid = "DenyUnEncryptedObjectUploads"

    effect = "Deny"

    not_principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "true"
      ]
    }
  }

  statement {
    sid = "EnforceTlsRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Build an S3 bucket to store cloudtrail archives
resource "aws_s3_bucket" "resize_images" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = false
  policy        = data.aws_iam_policy_document.prevent_unencrypted_uploads.json

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  tags = merge(
    map(
      "Name", local.bucket_name,
    ),
    local.tags
  )
}

# Disable public access on cloudtrail bucket
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket                  = aws_s3_bucket.resize_images.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
