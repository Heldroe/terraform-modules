resource "cloudflare_workers_route" "registry" {
  count = var.use_worker ? 1 : 0

  zone_id = var.cloudflare_zone_id
  pattern = "${var.registry_domain}/*"
  script  = cloudflare_workers_script.registry[0].script_name
}

resource "cloudflare_workers_script" "registry" {
  count = var.use_worker ? 1 : 0

  account_id  = var.cloudflare_account_id
  script_name = "tfr-static"
  main_module = "index.js"
  content     = file("${path.module}/function/function.js")
}
