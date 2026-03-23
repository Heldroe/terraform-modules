terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.8"
    }
  }
  required_version = ">= 1.0"
}
