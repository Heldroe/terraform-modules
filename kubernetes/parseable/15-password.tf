resource "random_password" "admin" {
  count = var.admin_password == null ? 1 : 0

  length  = 32
  special = false
}
