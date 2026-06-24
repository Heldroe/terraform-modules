resource "random_string" "suffix" {
  count = var.add_random_suffix ? 1 : 0

  length = var.random_suffix_length

  special = false
  upper   = false
}

resource "scaleway_object_bucket" "bucket" {
  name   = local.bucket_name
  region = var.region

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      id                                     = lifecycle_rule.key
      prefix                                 = lifecycle_rule.value.prefix
      enabled                                = lifecycle_rule.value.enabled
      tags                                   = lifecycle_rule.value.tags
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration != null ? [lifecycle_rule.value.expiration] : []

        content {
          days = expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition != null ? [lifecycle_rule.value.transition] : []

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}

resource "scaleway_object_bucket_server_side_encryption_configuration" "sse" {
  count = var.enable_sse ? 1 : 0

  bucket = scaleway_object_bucket.bucket.name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "scaleway_object_bucket_policy" "bucket" {
  bucket = scaleway_object_bucket.bucket.id

  policy = jsonencode({
    Version = "2023-04-17"
    Statement = [
      {
        Sid    = "AllowAdminFullAccess"
        Effect = "Allow"
        Principal = {
          SCW = concat(
            formatlist("user_id:%s", var.admin_user_ids),
            formatlist("application_id:%s", var.admin_application_ids),
          )
        }
        Action = ["s3:*"]
        Resource = [
          scaleway_object_bucket.bucket.name,
          "${scaleway_object_bucket.bucket.name}/*",
        ]
      },
      {
        Sid    = "AllowReadOnlyAccess"
        Effect = "Allow"
        Principal = {
          SCW = formatlist("application_id:%s", var.readonly_application_ids)
        }
        Action = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetObject",
        ]
        Resource = [
          scaleway_object_bucket.bucket.name,
          "${scaleway_object_bucket.bucket.name}/*",
        ]
      },
      {
        Sid    = "AllowReadWriteAccess"
        Effect = "Allow"
        Principal = {
          SCW = formatlist("application_id:%s", var.readwrite_application_ids)
        }
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
        ]
        Resource = [
          scaleway_object_bucket.bucket.name,
          "${scaleway_object_bucket.bucket.name}/*",
        ]
      },
    ]
  })
}
