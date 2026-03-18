resource "tls_private_key" "ssh" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "hcloud_ssh_key" "key" {
  name       = var.name
  public_key = tls_private_key.ssh.public_key_openssh
}
