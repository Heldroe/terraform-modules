module "fluentbit" {
  source  = "tfr.davidguerrero.fr/modules/helm-release/kubernetes"
  version = "~> 0.1.0"

  release_name     = "fluent-bit"
  namespace_name   = local.namespace
  create_namespace = false # Handled by this module

  repository = "https://fluent.github.io/helm-charts"

  chart_name    = "fluent-bit"
  chart_version = var.chart_version

  yaml_values = [
    yamlencode(
      {
        image = {
          repository = var.image_repository
          tag        = var.image_tag
        }
        env = [
          {
            name = "AWS_ACCESS_KEY_ID"
            valueFrom = {
              secretKeyRef = {
                name = kubernetes_secret_v1.bucket.metadata[0].name
                key  = "aws_access_key_id"
              }
            }
          },
          {
            name = "AWS_SECRET_ACCESS_KEY"
            valueFrom = {
              secretKeyRef = {
                name = kubernetes_secret_v1.bucket.metadata[0].name
                key  = "aws_secret_access_key"
              }
            }
          },
        ]
        luaScripts = {
          "schema.lua" = file("${path.module}/lua/schema.lua")
        }
        config = {
          filters = <<EOF
[FILTER]
    Name                 kubernetes
    Match                kube.*
    Merge_Log            Off
    Keep_Log             Off
    Labels               On
    Annotations          Off
    K8S-Logging.Parser   On
    K8S-Logging.Exclude  On

[FILTER]
    Name            record_modifier
    Match           *
    UUID_Key        log_id

[FILTER]
    Name            lua
    Match           *
    script          /fluent-bit/scripts/schema.lua
    call            format_for_parquet
EOF
          outputs = <<EOF
[OUTPUT]
    Name s3
    Match           *
    Endpoint        ${var.bucket_endpoint}
    Region          ${var.bucket_region}
    Bucket          ${var.bucket_name}
    Total_File_Size 1M
    Upload_Timeout  1m
    Use_Put_Object  On
    Compression     parquet
    s3_key_format   /raw/containers/year=%Y/month=%m/day=%d/hour=%H/$UUID.parquet
EOF
        }
      }
    ),
  ]
}
