locals {
  dir_redirect_ignore = [
    "*.json",
    "*.tar.gz",
    "*.ico",
    "*.svg",
    "*.png",
    "*/versions",
    "*/download",
  ]
  forward_slash_ignore = concat(["*/"], local.dir_redirect_ignore)
}
