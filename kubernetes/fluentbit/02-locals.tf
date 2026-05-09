locals {
  namespace = var.create_namespace ? kubernetes_namespace_v1.namespace[0].metadata[0].name : var.namespace_name

  aggregator_name = "fluent-bit-aggregator"
  aggregator_port = 24224

  metrics_port = 2020

  # Compactor settings
  compactor_app_label = "parquet-compactor"

  compactor_common_env = {
    BUCKET_NAME  = var.bucket_name
    S3_ENDPOINT  = var.bucket_endpoint
    S3_REGION    = var.bucket_region
    CATEGORIES   = "containers"
    DELETE_FILES = "true"
  }

  compactor_secret_env = [
    {
      name       = "AWS_ACCESS_KEY_ID"
      secret_key = "aws_access_key_id"
    },
    {
      name       = "AWS_SECRET_ACCESS_KEY"
      secret_key = "aws_secret_access_key"
    },
  ]

  compactor_resources = {
    requests = { cpu = "100m", memory = "100Mi" }
    limits   = { cpu = "500m", memory = "250Mi" }
  }

  compactor_jobs = merge(
    {
      hourly = {
        name     = "hourly-compactor"
        schedule = var.hourly_compactor_schedule
        mode     = "hourly"
      }
    },
    var.enable_daily_compactor ? {
      daily = {
        name     = "daily-compactor"
        schedule = var.daily_compactor_schedule
        mode     = "daily"
      }
    } : {}
  )
}
