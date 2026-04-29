resource "cloudflare_ruleset" "registry_protocol" {
  count = var.use_worker ? 0 : 1

  zone_id     = var.cloudflare_zone_id
  name        = "Terraform module registry protocol"
  description = "Appends X-Terraform-Get to /download requests."
  kind        = "zone"
  phase       = "http_response_headers_transform"
  rules = [
    {
      action      = "rewrite"
      description = "Terraform module registry protocol"
      action_parameters = {
        headers = {
          "X-Terraform-Get" = {
            operation = "set"
            value     = "./module.tar.gz"
          }
        }
      }
      expression = "(http.host == \"${var.registry_domain}\" and ends_with(http.request.uri.path, \"/download\"))"
      enabled    = true
    },
  ]
}

resource "cloudflare_ruleset" "index_rewrite" {
  count = var.use_worker ? 0 : 1

  zone_id     = var.cloudflare_zone_id
  name        = "Index file rewrite"
  description = "Fetches index.html when a directory is requested."
  kind        = "zone"
  phase       = "http_request_transform"
  rules = [
    {
      action      = "rewrite"
      description = "Index file rewrite"
      action_parameters = {
        uri = {
          path = {
            expression = "concat(http.request.uri.path, \"index.html\")"
          }
        }
      }
      expression = "(http.host == \"${var.registry_domain}\" and ends_with(http.request.uri.path, \"/\"))"
      enabled    = true
    },
  ]
}

resource "cloudflare_ruleset" "trailing_slash_redirect" {
  count = var.use_worker ? 0 : 1

  zone_id     = var.cloudflare_zone_id
  name        = "Trailing slash redirect"
  description = "Redirects directory paths to include a trailing slash."
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"
  rules = [
    {
      action      = "redirect"
      description = "Trailing slash redirect"
      action_parameters = {
        from_value = {
          status_code = 301
          target_url = {
            expression = "concat(\"https://\", http.host, http.request.uri.path, \"/\")"
          }
          preserve_query_string = true
        }
      }
      expression = "(http.host == \"${var.registry_domain}\" and not ends_with(http.request.uri.path, \"/\") and not (http.request.uri.path contains \".\") and not ends_with(http.request.uri.path, \"/versions\") and not ends_with(http.request.uri.path, \"/download\"))"
      enabled    = true
    },
  ]
}
