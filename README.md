# David's Terraform modules

This repository holds the source of all my personal Terraform modules. All modules are published with [`tfr-static`](https://github.com/Heldroe/tfr-static/) to [my public Terraform registry](https://tfr.davidguerrero.fr/).

## Linting

All modules are linted with [`tflint`](https://github.com/terraform-linters/tflint) and my own set of rules: [`tflint-ruleset-terraform-style`](https://github.com/Heldroe/tflint-ruleset-terraform-style) (see [*An opinionated Terraform style guide*](https://davidguerrero.fr/blog/terraform-style-guide/) on my blog).

Additionally, `terraform fmt` and `terraform validate` are also checked.

You can run the linting suite on the module you're currently developing by running `make`.

## To-do

* Scaleway bucket: split bucket-level and object-level permissions in the policy (see https://www.scaleway.com/en/docs/object-storage/api-cli/bucket-policy/#action)
