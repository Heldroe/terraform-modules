module "parseable" {
  source = "../helm/release" # TODO: use versioned module release

  repository = "https://charts.parseable.com"
  chart_name = "parseable"

  release_name     = var.name
  chart_version    = "2.5.13"
  namespace_name   = local.namespace
  create_namespace = false

  yaml_values = [
    yamlencode(
      {
        parseable = {
          image = {
            tag = "v2.6.3"
          }
          store = "s3-store"
          auditLogging = {
            enabled = false
          }
          s3ModeSecret = {
            enabled = true
          }
          gcsModeSecret = {
            enabled = false
          }
          persistence = {
            staging = {
              enabled = false
              # storageClass = "hcloud-volumes"
            }
          }
          env = local.shared_env
          highAvailability = {
            enabled = var.enable_ha
            env     = local.shared_env
            ingestor = {
              count = var.ingestor_ha_replicas
              env   = local.shared_env
            }
          }
        }
      }
    ),
  ]
}

module "fluentbit" {
  count = var.install_filebeat ? 1 : 0

  source = "../helm/release" # TODO: use versioned module release

  repository = "https://fluent.github.io/helm-charts"
  chart_name = "fluent-bit"

  release_name     = "fluentbit"
  chart_version    = "0.56.0"
  namespace_name   = local.namespace
  create_namespace = false

  yaml_values = [
    yamlencode(
      {
        config = {
          filters = <<EOF
[FILTER]
    Name                 kubernetes
    Match                kube.*
    Merge_Log            On
    Keep_Log             Off
    K8S-Logging.Parser   On
    K8S-Logging.Exclude  On

[FILTER]
    Name          rewrite_tag
    Match         kube.*
    Rule          $kubernetes['pod_name'] ^envoy-gateway-.* envoy_gateway_logs false
    Emitter_Name  envoy_logs_emitter
EOF
          outputs = <<EOF
[OUTPUT]
    Name                 http
    Match                kube.*
    host                 ${local.ingestion_service}.${local.namespace}.svc.cluster.local
    uri                  /api/v1/ingest
    port                 80
    http_User            ${var.admin_username}
    http_Passwd          ${local.admin_password}
    format               json
    compress             gzip
    header               Content-Type application/json
    header               X-P-Stream kubernetes
    json_date_key        timestamp
    json_date_format     iso8601

[OUTPUT]
    Name                 http
    Match                envoy_gateway_logs
    host                 ${local.ingestion_service}.${local.namespace}.svc.cluster.local
    uri                  /api/v1/ingest
    port                 80
    http_User            ${var.admin_username}
    http_Passwd          ${local.admin_password}
    format               json
    compress             gzip
    header               Content-Type application/json
    header               X-P-Stream envoy_access_logs
    json_date_key        timestamp
    json_date_format     iso8601
EOF
        }
      }
    ),
  ]
}
