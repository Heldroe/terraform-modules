terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3"
    }
  }
  required_version = ">= 1.0"
}
