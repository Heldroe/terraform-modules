locals {
  bucket_name = var.add_random_suffix ? "${var.name}-${random_string.suffix[0].result}" : var.name
}
