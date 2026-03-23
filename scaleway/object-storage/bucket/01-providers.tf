terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.70"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.8"
    }
  }
  required_version = ">= 1.0"
}
