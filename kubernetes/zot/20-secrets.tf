resource "kubernetes_secret_v1" "s3" {
  metadata {
    name      = "zot-s3-credentials"
    namespace = local.namespace
  }

  data = {
    aws_access_key_id     = var.bucket_access_key
    aws_secret_access_key = var.bucket_secret_key
  }

  type = "Opaque"
}

resource "random_password" "kubernetes_probes" {
  length      = 32
  min_numeric = 5
  special     = false # Some special characters can cause issues
}

resource "htpasswd_password" "kubernetes_probes" {
  password = random_password.kubernetes_probes.result
}
