resource "kubernetes_secret_v1" "registry_credentials" {
  count = var.registry_credentials != null ? 1 : 0

  metadata {
    name      = "pull-secret"
    namespace = local.namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.registry_credentials.domain) = {
          username = var.registry_credentials.username
          password = var.registry_credentials.password
          auth     = base64encode("${var.registry_credentials.username}:${var.registry_credentials.password}")
        }
      }
    })
  }
}

resource "random_password" "secret_key" {
  length      = 50
  min_special = 5
  min_numeric = 5
}

resource "random_password" "creator_hash_salt" {
  length      = 50
  min_special = 5
  min_numeric = 5
}

resource "random_bytes" "altcha_hmac" {
  length = 64
}
