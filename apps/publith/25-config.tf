resource "kubernetes_config_map_v1" "app_config" {
  metadata {
    name      = "app-config"
    namespace = local.namespace
  }

  data = merge({
    DATABASE_NAME = var.database_name
    DATABASE_HOST = var.database_host
  }, var.config)
}

resource "kubernetes_secret_v1" "app_secrets" {
  metadata {
    name      = "app-secrets"
    namespace = local.namespace
  }

  data = {
    DATABASE_USER              = var.database_username
    DATABASE_PASSWORD          = var.database_password
    CACHE_URL                  = var.cache_url
    SECRET_KEY                 = random_password.secret_key.result
    ALTCHA_HMAC_KEY            = random_bytes.altcha_hmac.hex
    MESSAGES_CREATOR_HASH_SALT = random_password.creator_hash_salt.result
  }
}
