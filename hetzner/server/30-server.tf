resource "hcloud_server" "node" {
  name         = var.name
  ssh_keys     = [hcloud_ssh_key.key.id]
  firewall_ids = var.firewall_ids

  image       = var.image
  server_type = var.server_type
  location    = var.location

  placement_group_id = var.placement_group_id

  user_data = templatefile(
    "${path.module}/templates/cloud-init.yaml",
    {
      server_name           = var.use_netbird ? "${var.name}.netbird.cloud" : var.name
      hetzner_location      = var.location
      k3s_version           = var.k3s_version
      agent_mode            = var.agent_mode
      netbird_setup_key     = var.use_netbird ? netbird_setup_key.server[0].key : null
      tailscale_auth_key    = var.use_tailscale ? tailscale_tailnet_key.key[0].key : null
      aws_region            = var.kubeconfig_aws_region
      aws_access_key_id     = var.kubeconfig_aws_access_key_id
      aws_secret_access_key = var.kubeconfig_aws_secret_access_key
      ssm_parameter_name    = var.kubeconfig_ssm_parameter_name
      dockerhub_username    = var.dockerhub_username
      dockerhub_token       = var.dockerhub_token
      private_ip            = var.private_ip
      cluster_token         = local.cluster_token
      cluster_peer_host     = local.peer_host
    }
  )

  labels = merge(
    {
      (local.cluster_label_key) = var.cluster_name
      cluster_token             = local.cluster_token

      # We expose the private IP as label for peers to find it as data.hcloud_servers does not expose networks.
      private_ip = var.private_ip
    },
    var.agent_mode ? { role = "agent" } : { role = "server" }
  )

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  lifecycle {
    # Don't recreate the server on user data change
    ignore_changes = [user_data]
  }
}

resource "hcloud_server_network" "node" {
  count = var.subnet_id != null ? 1 : 0

  server_id = hcloud_server.node.id
  subnet_id = var.subnet_id
  ip        = var.private_ip
}
