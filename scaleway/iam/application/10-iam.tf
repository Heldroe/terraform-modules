resource "scaleway_iam_application" "application" {
  name        = local.application_name
  description = var.description
}

resource "scaleway_iam_api_key" "key" {
  application_id = scaleway_iam_application.application.id
  description    = var.description
}

resource "scaleway_iam_policy" "application" {
  count = length(var.permission_sets) > 0 ? 1 : 0

  name           = local.application_name
  application_id = scaleway_iam_application.application.id
  rule {
    project_ids          = [var.project_id]
    permission_set_names = var.permission_sets
  }
}
