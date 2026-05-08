locals {
  bucket_name = var.add_random_suffix ? "${var.name}-${random_string.suffix[0].result}" : var.name

  regional_endpoint_domain = "s3.${var.region}.scw.cloud"
}
