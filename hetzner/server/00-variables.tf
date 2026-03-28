variable "name" {
  type        = string
  description = "Name of the server."
}

variable "image" {
  type        = string
  default     = "ubuntu-24.04"
  description = "Image identifier."
}

variable "server_type" {
  type        = string
  default     = "cax11"
  description = "Server type."
}

variable "location" {
  type        = string
  default     = "nbg1"
  description = "Server location."
}

variable "k3s_version" {
  type        = string
  default     = "v1.35.1"
  description = "Version of k3s to install."
}

variable "agent_mode" {
  type        = bool
  default     = false
  description = "Run the server in k3s agent mode (requires an existing control plane)."
}

variable "firewall_ids" {
  type        = list(string)
  default     = []
  description = "List of firewall IDs to attach to the server."
}

variable "api_server_domain" {
  type        = string
  default     = null
  description = "Kubernetes API server domain to add to the API server certificate."
}

# Tailscale

variable "use_tailscale" {
  type        = bool
  default     = false
  description = "Set to true to enable Tailscale. Cannot be true if use_netbird is true."
}

variable "tailscale_tailnet_name" {
  type        = string
  description = "Tailscale Tailnet name."
}

variable "disable_tailscale_key_expiry" {
  type        = bool
  default     = true
  description = "Disable Tailscale key expiry. Should always be true unless the server didn't come up properly and you still need to destroy resources."
}

# Netbird

variable "use_netbird" {
  type        = bool
  default     = false
  description = "Set to true to enable NetBird. Cannot be true if use_tailscale is true."
}

variable "netbird_group_ids" {
  type        = list(string)
  default     = []
  description = "List of NetBird group IDs to assign to the server."
}

variable "netbird_domain" {
  type        = string
  default     = "netbird.cloud"
  description = "NetBird DNS suffix for peer hostnames."
}

check "vpn_exclusivity" {
  assert {
    condition     = !(var.use_tailscale && var.use_netbird)
    error_message = "Configuration error: var.use_tailscale and var.use_netbird cannot both be true at the same time."
  }
}

variable "kubeconfig_aws_region" {
  type        = string
  description = "AWS region used to set the kubeconfig SSM parameter."
}

variable "kubeconfig_aws_access_key_id" {
  type        = string
  description = "AWS access key ID used to set the kubeconfig SSM parameter."
}

variable "kubeconfig_aws_secret_access_key" {
  type        = string
  sensitive   = true
  description = "AWS secret access key used to set the kubeconfig SSM parameter."
}

variable "kubeconfig_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name where to set the kubeconfig."
}

variable "dockerhub_username" {
  type        = string
  sensitive   = true
  description = "DockerHub credentials username."
}

variable "dockerhub_token" {
  type        = string
  sensitive   = true
  description = "DockerHub credentials token."
}

variable "placement_group_id" {
  type        = string
  default     = null
  description = "Placement group ID."
}

variable "private_ip" {
  type        = string
  default     = null
  description = "The private IP to use within the private network."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The network subnet ID to create the server in."
}

variable "cluster_name" {
  type        = string
  description = "Cluster name to use as tag and discover peers."
}

variable "bunnynet_dns_zone_id" {
  type        = string
  description = "Bunny.net DNS zone ID to create a record for the server."
}

variable "add_public_ingress_labels" {
  type        = bool
  default     = false
  description = "Whether to add the public ingress labels."
}
