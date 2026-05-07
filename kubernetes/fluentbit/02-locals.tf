locals {
  namespace = var.create_namespace ? kubernetes_namespace_v1.namespace[0].metadata[0].name : var.namespace_name

  aggregator_name = "fluent-bit-aggregator"
  aggregator_port = 24224

  metrics_port = 2020
}
