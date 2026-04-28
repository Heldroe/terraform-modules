module "bucket" {
  source  = "tfr.davidguerrero.fr/modules/object-storage-bucket/scaleway"
  version = "~> 0.1.0"

  name   = var.bucket_name
  region = var.bucket_region

  admin_user_ids = var.scaleway_admin_user_ids

  readonly_application_ids  = [module.read_user.id]
  readwrite_application_ids = [module.write_user.id]
}
