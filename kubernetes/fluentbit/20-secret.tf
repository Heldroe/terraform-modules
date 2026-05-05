resource "kubernetes_secret_v1" "bucket" {
  metadata {
    name      = "bucket-credentials"
    namespace = local.namespace
  }

  data = merge({
    "aws_access_key_id"     = var.bucket_access_key
    "aws_secret_access_key" = var.bucket_secret_key
  })

  type = "Opaque"
}
