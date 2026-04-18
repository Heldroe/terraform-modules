terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.31"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5"
    }
  }
  required_version = ">= 1.14.4"
}
