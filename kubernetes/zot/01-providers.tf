terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "~> 2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.0"
    }
  }
  required_version = ">= 1.0"
}
