locals {
  namespace = var.create_namespace ? kubernetes_namespace_v1.namespace[0].metadata[0].name : var.namespace

  ingestion_service = var.enable_ha ? "parseable-ingestor-service" : "parseable"

  admin_password = coalesce(var.admin_password, random_password.admin[0].result)

  shared_env = {
    RUST_LOG = var.log_level
  }
}
