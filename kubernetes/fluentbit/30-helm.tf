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
    Name                nest
    Match               *
    Operation           lift
    Nested_under        kubernetes
    Add_prefix          k8s_

[FILTER]
    Name                modify
    Match               *
    Rename              k8s_namespace_name  namespace
    Rename              k8s_pod_name        pod
    Rename              k8s_container_name  container
    Rename              k8s_host            node

[FILTER]
    Name                modify
    Match               *
    Add                 namespace  unknown
    Add                 pod        unknown
    Add                 container  unknown
    Add                 node       unknown
    Add                 log        ""

[FILTER]
    Name                record_modifier
    Match               *
    UUID_Key            id
    # Allowlist guarantees absolutely no schema drift in Parquet
    Allowlist_key       time
    Allowlist_key       id
    Allowlist_key       namespace
    Allowlist_key       pod
    Allowlist_key       container
    Allowlist_key       node
    Allowlist_key       log
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
