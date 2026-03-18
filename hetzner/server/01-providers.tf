terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.60"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.13.7"
    }
    netbird = {
      source  = "netbirdio/netbird"
      version = "0.0.9"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }
  required_version = ">= 1.0"
}
