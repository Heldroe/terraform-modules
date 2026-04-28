terraform {
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    bunnynet = {
      source = "BunnyWay/bunnynet"
    }
    # tflint-ignore: terraform_unused_required_providers
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 1.14.4"
}
