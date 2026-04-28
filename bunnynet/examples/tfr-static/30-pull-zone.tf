module "registry" {
  source  = "tfr.davidguerrero.fr/modules/pull-zone/bunnynet"
  version = "~> 0.1.1"

  name = var.pull_zone_name

  additional_hostnames = []

  origin_hostname = "s3.${module.bucket.region}.scw.cloud"
  origin_path     = "/${module.bucket.name}/"

  s3_auth_enabled = true
  s3_auth_key     = module.read_user.access_key
  s3_auth_secret  = module.read_user.secret_key
  s3_auth_region  = module.bucket.region

  block_root_path    = false
  enable_smart_cache = false

  edge_rules = {
    "terraform-registry" = {
      description = "Terraform registry protocol"
      priority    = 1
      match_type  = "MatchAny"
      triggers = [
        {
          type       = "Url"
          match_type = "MatchAny"
          patterns   = ["*/download"]
        },
      ]
      actions = [
        {
          type       = "SetStatusCode"
          parameter1 = "204"
        },
        {
          type       = "SetResponseHeader"
          parameter1 = "X-Terraform-Get"
          parameter2 = "https://%%{Url.Hostname}%%{Url.Directory}module.tar.gz"
        },
      ]
    }
    "serve-index-files" = {
      description = "Serve index files"
      priority    = 2
      match_type  = "MatchAny"
      triggers = [
        {
          type       = "Url"
          match_type = "MatchAny"
          patterns   = ["*/"]
        },
      ]
      actions = [
        {
          type       = "OriginUrl"
          parameter1 = "https://s3.${module.bucket.region}.scw.cloud/${module.bucket.name}%%{Url.Path}index.html"
        },
      ]
    }
    "add-forward-slash" = {
      description = "Add forward slashes"
      priority    = 3
      match_type  = "MatchNone"
      triggers = [
        {
          type       = "Url"
          match_type = "MatchAny"
          patterns   = slice(local.forward_slash_ignore, 0, 5)
        },
        {
          type       = "Url"
          match_type = "MatchAny"
          patterns   = slice(local.forward_slash_ignore, 5, length(local.forward_slash_ignore))
        },
      ]
      actions = [
        {
          type       = "Redirect"
          parameter1 = "https://%%{Url.Hostname}%%{Url.Path}/"
          parameter2 = "301" # redirect status code
        },
      ]
    }
  }
}
