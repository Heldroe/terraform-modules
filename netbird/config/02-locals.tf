locals {
  all_groups = setunion(
    var.client_groups,
    keys(var.remote_cluster_groups),
  )
}
