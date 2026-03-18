data "tailscale_device" "server" {
  count = var.use_tailscale && var.disable_tailscale_key_expiry ? 1 : 0

  name     = "${var.name}.${var.tailscale_tailnet_name}"
  wait_for = "120s"

  depends_on = [hcloud_server.node]
}

data "hcloud_servers" "cluster_peers" {
  with_selector = "${local.cluster_label_key}=${var.cluster_name},role=server"
  with_status   = ["running"]
}
