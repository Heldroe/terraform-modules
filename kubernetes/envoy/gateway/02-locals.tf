locals {
  namespace = var.create_namespace ? kubernetes_namespace_v1.namespace[0].metadata[0].name : var.namespace

  escaped_hostnames = {
    for hostname in keys(var.hostnames) : hostname => replace(hostname, ".", "-")
  }
}
