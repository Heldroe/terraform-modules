resource "kubernetes_secret_v1" "db" {
  metadata {
    name      = "grafana-db-credentials"
    namespace = local.namespace
  }

  data = {
    username = var.database_username
    password = var.database_password
  }

  type = "kubernetes.io/basic-auth"
}

resource "kubernetes_secret_v1" "s3" {
  metadata {
    name      = "grafana-s3-credentials"
    namespace = local.namespace
  }

  data = {
    aws_access_key_id     = var.logs_bucket_access_key_id
    aws_secret_access_key = var.logs_bucket_secret_access_key
  }

  type = "Opaque"
}

resource "random_password" "admin" {
  length      = 32
  min_special = 5
  min_numeric = 5
}
