module "read_user" {
  source  = "tfr.davidguerrero.fr/modules/iam-application/scaleway"
  version = "~> 0.1.0"

  project_id = var.scaleway_project_id

  name        = var.bucket_read_user_name
  description = "Bunny.net CDN."

  permission_sets = ["ObjectStorageReadOnly"]
}

module "write_user" {
  source  = "tfr.davidguerrero.fr/modules/iam-application/scaleway"
  version = "~> 0.1.0"

  project_id = var.scaleway_project_id

  name        = var.bucket_write_user_name
  description = "Registry uploader."

  permission_sets = ["ObjectStorageFullAccess"]
}
