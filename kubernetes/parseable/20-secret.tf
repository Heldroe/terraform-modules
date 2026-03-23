resource "kubernetes_secret_v1" "parseable" {
  metadata {
    name      = "parseable-env-secret"
    namespace = local.namespace
  }

  data = merge({
    "s3.url"        = "https://s3.${var.s3_region}.scw.cloud"
    "s3.access.key" = var.s3_access_key
    "s3.secret.key" = var.s3_secret_key
    "s3.bucket"     = var.s3_bucket
    "s3.region"     = var.s3_region

    "addr"        = "0.0.0.0:8000"
    "staging.dir" = "./staging"
    "fs.dir"      = "./data"
    "username"    = var.admin_username
    "password"    = local.admin_password
  })

  type = "Opaque"
}
