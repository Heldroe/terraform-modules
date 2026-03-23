resource "random_string" "suffix" {
  count = var.add_random_suffix ? 1 : 0

  length = var.random_suffix_length

  special = false
  upper   = false
}

resource "scaleway_object_bucket" "bucket" {
  name   = local.bucket_name
  region = var.region
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
          SCW = formatlist("application_id:%s", var.read_application_ids)
        }
        Action = [
          "s3:ListBucket",
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
        ]
        Resource = [
          scaleway_object_bucket.bucket.name,
          "${scaleway_object_bucket.bucket.name}/*",
        ]
      },
    ]
  })
}
