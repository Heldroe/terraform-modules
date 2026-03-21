terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3"
    }
  }
  required_version = ">= 1.0"
}
